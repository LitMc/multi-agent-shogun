#!/usr/bin/env bash
set -euo pipefail

# Keep inbox watchers alive in a persistent tmux-hosted shell.
# This script is designed to run forever.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$SCRIPT_DIR"

source "$SCRIPT_DIR/lib/agent_registry.sh"

mkdir -p logs queue/inbox

get_multiagent_pane_base() {
    if [ -n "${SHOGUN_PANE_BASE:-}" ]; then
        echo "$SHOGUN_PANE_BASE"
        return 0
    fi
    tmux show-options -gv pane-base-index 2>/dev/null || echo 0
}

ensure_inbox_file() {
    local agent="$1"
    if [ ! -f "queue/inbox/${agent}.yaml" ]; then
        printf 'messages: []\n' > "queue/inbox/${agent}.yaml"
    fi
}

pane_exists() {
    local pane="$1"
    # Resolve via tmux directly so both "shogun:main" and
    # "multiagent:agents.N" targets are accepted (an exact-string match
    # against list-panes output rejected the shogun window target).
    tmux display-message -t "$pane" -p '#{pane_id}' >/dev/null 2>&1
}

start_watcher_if_missing() {
    local agent="$1"
    local pane="$2"
    local log_file="$3"
    local cli
    local lockfile="/tmp/shogun_watcher_start_${agent}.lock"

    ensure_inbox_file "$agent"
    if ! pane_exists "$pane"; then
        return 0
    fi

    (
        flock -n 9 || return 0
        # NB: no -E flag — BSD/macOS pgrep rejects it ("illegal option -- E"),
        # which made this dedup silently error out and spawn duplicate watchers
        # (incl. a second shogun watcher on the live pane). pgrep -f already
        # treats the pattern as an extended regex on both BSD and GNU. (cmd_466)
        if pgrep -f "scripts/inbox_watcher.sh ${agent} ${pane}( |$)" >/dev/null 2>&1; then
            return 0
        fi

        if pgrep -f "scripts/inbox_watcher.sh ${agent} " >/dev/null 2>&1; then
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WARN] stale watcher detected for ${agent}; starting watcher for expected pane ${pane}" >&2
        fi

        # Shogun runs in safe mode (event-driven only, no escalation) to match
        # shutsujin_departure.sh STEP 6.6; respawning without these flags would
        # re-enable escalation and risk a self-nudge loop on the shogun pane.
        local env_prefix=""
        local cli_default="codex"
        if [ "$agent" = "shogun" ]; then
            env_prefix="env ASW_DISABLE_ESCALATION=1 ASW_PROCESS_TIMEOUT=0 ASW_DISABLE_NORMAL_NUDGE=0"
            cli_default="claude"
        fi

        cli=$(tmux show-options -p -t "$pane" -v @agent_cli 2>/dev/null || echo "$cli_default")
        # 9>&- closes the flock FD in the child. Otherwise the spawned watcher
        # (and its fswatch/inotifywait grandchildren) inherit the lock and hold
        # it for the life of the process; when that watcher later dies, an
        # orphaned fswatch child keeps the lock held (~30s), blocking flock -n 9
        # on the next loop and preventing the respawn entirely. (cmd_466)
        nohup $env_prefix bash scripts/inbox_watcher.sh "$agent" "$pane" "$cli" >> "$log_file" 2>&1 9>&- &
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [START] inbox_watcher started for ${agent} pane=${pane} PID=$!" >&2
    ) 9>"$lockfile"
}

watcher_specs() {
    local pane_base
    local agent
    pane_base=$(get_multiagent_pane_base)

    while IFS= read -r agent; do
        [ -z "$agent" ] && continue
        local pane
        if ! pane=$(agent_registry_pane_for_agent "$agent" "$pane_base"); then
            continue
        fi
        printf '%s\t%s\tlogs/inbox_watcher_%s.log\n' "$agent" "$pane" "$agent"
    done < <(agent_registry_agents)
}

start_all_watchers() {
    local agent pane log_file
    while IFS=$'\t' read -r agent pane log_file; do
        start_watcher_if_missing "$agent" "$pane" "$log_file"
    done < <(watcher_specs)
}

if [ "${1:-}" = "--print-watchers" ]; then
    watcher_specs
    exit 0
fi

while true; do
    start_all_watchers
    sleep 5
done
