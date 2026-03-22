#!/usr/bin/env bash
# agent_kill.sh — Kill and optionally restart a Claude Code agent in a tmux pane
# Usage: bash scripts/agent_kill.sh <agent_id> [--restart]
#
# IMPORTANT: --remote-control --permission-mode bypassPermissions は必須フラグ。
# これなしで起動した足軽・軍師はファイル操作で許可プロンプトに止まり、
# 誰も許可を押せないためフリーズする。
# 初期起動時も必ずこのフラグを使用すること:
#   claude --model opus --remote-control --permission-mode bypassPermissions
#
# Safety: Only kills claude processes that are direct children of the target
# tmux pane's shell. Will NOT kill arbitrary processes.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# Agent-to-session:pane mapping
get_target() {
    case "$1" in
        shogun) echo "shogun:main.0" ;;
        karo|ashigaru[1-7]|gunshi) echo "multiagent:$1.0" ;;
        *) echo "" ;;
    esac
}

usage() {
    echo "Usage: $0 <agent_id> [--restart]"
    echo "  agent_id: shogun, karo, ashigaru1-7, gunshi"
    echo "  --restart: restart Claude Code after kill"
    exit 1
}

if [[ $# -lt 1 ]]; then
    usage
fi

AGENT_ID="$1"
RESTART=false
if [[ "${2:-}" == "--restart" ]]; then
    RESTART=true
fi

# Validate agent_id
TARGET="$(get_target "$AGENT_ID")"
if [[ -z "$TARGET" ]]; then
    echo "ERROR: Unknown agent_id: $AGENT_ID"
    echo "Valid agents: shogun, karo, ashigaru1-7, gunshi"
    exit 1
fi

# Get pane shell PID
SHELL_PID=$(tmux display-message -t "$TARGET" -p '#{pane_pid}' 2>/dev/null) || {
    echo "ERROR: Cannot find pane $TARGET"
    exit 1
}

echo "Agent: $AGENT_ID (pane $TARGET, shell PID $SHELL_PID)"

# Find claude process as direct child of the shell
CLAUDE_PID=$(pgrep -P "$SHELL_PID" -f "claude" 2>/dev/null | head -1) || true

if [[ -z "$CLAUDE_PID" ]]; then
    echo "No claude process found as child of shell PID $SHELL_PID"
    if $RESTART; then
        echo "Starting Claude Code..."
        tmux send-keys -t "$TARGET" "claude --model opus --remote-control --permission-mode bypassPermissions --name $AGENT_ID" Enter
        echo "Restart command sent."
    fi
    exit 0
fi

# Verify it's actually a claude process
CLAUDE_CMD=$(ps -o command= -p "$CLAUDE_PID" 2>/dev/null) || true
if [[ ! "$CLAUDE_CMD" =~ claude ]]; then
    echo "ERROR: PID $CLAUDE_PID is not a claude process: $CLAUDE_CMD"
    exit 1
fi

echo "Found claude process: PID $CLAUDE_PID"
echo "  Command: $CLAUDE_CMD"
echo "  CPU: $(ps -o %cpu= -p "$CLAUDE_PID" 2>/dev/null)%"
echo "  MEM: $(ps -o %mem= -p "$CLAUDE_PID" 2>/dev/null)%"
echo "  Elapsed: $(ps -o etime= -p "$CLAUDE_PID" 2>/dev/null)"

# Kill child processes first (subagents, MCP servers)
CHILDREN=$(pgrep -P "$CLAUDE_PID" 2>/dev/null) || true
if [[ -n "$CHILDREN" ]]; then
    echo "Killing child processes: $CHILDREN"
    for cpid in $CHILDREN; do
        kill -9 "$cpid" 2>/dev/null || true
    done
    sleep 0.5
fi

# Kill the claude process
echo "Sending SIGKILL to PID $CLAUDE_PID..."
kill -9 "$CLAUDE_PID" 2>/dev/null || true

# Wait for process to die (up to 5 seconds)
for i in 1 2 3 4 5; do
    if ! ps -p "$CLAUDE_PID" > /dev/null 2>&1; then
        echo "Process $CLAUDE_PID killed successfully (after ${i}s)."
        break
    fi
    if [[ $i -eq 5 ]]; then
        echo "WARNING: Process $CLAUDE_PID still alive after 5s. May need manual intervention."
        exit 1
    fi
    sleep 1
done

# Restart if requested
if $RESTART; then
    echo "Restarting Claude Code for $AGENT_ID..."
    sleep 1

    # Widen pane temporarily to prevent line-wrap corruption of send-keys commands
    ORIG_WIDTH=$(tmux display-message -t "$TARGET" -p '#{pane_width}' 2>/dev/null) || ORIG_WIDTH=""
    if [[ -n "$ORIG_WIDTH" ]] && (( ORIG_WIDTH < 200 )); then
        tmux resize-pane -t "$TARGET" -x 200 2>/dev/null || true
    fi

    # Clear any leftover input, then send command with literal flag to avoid line-wrap issues
    tmux send-keys -t "$TARGET" C-c 2>/dev/null || true
    sleep 0.3
    tmux send-keys -t "$TARGET" -l "claude --model opus --remote-control --permission-mode bypassPermissions --name $AGENT_ID"
    sleep 0.3
    tmux send-keys -t "$TARGET" Enter

    # Verify claude process started (up to 15 seconds)
    echo "Waiting for claude process to start..."
    for attempt in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do
        sleep 1
        NEW_PID=$(pgrep -P "$SHELL_PID" -f "claude" 2>/dev/null | head -1) || true
        if [[ -n "$NEW_PID" ]]; then
            echo "Claude Code started: PID $NEW_PID (after ${attempt}s)."
            break
        fi
        if [[ $attempt -eq 15 ]]; then
            echo "WARNING: Claude Code did not start after 15s. Retrying..."
            tmux send-keys -t "$TARGET" -l "claude --model opus --remote-control --permission-mode bypassPermissions --name $AGENT_ID"
            sleep 0.3
            tmux send-keys -t "$TARGET" Enter
            sleep 5
            RETRY_PID=$(pgrep -P "$SHELL_PID" -f "claude" 2>/dev/null | head -1) || true
            if [[ -n "$RETRY_PID" ]]; then
                echo "Claude Code started on retry: PID $RETRY_PID."
            else
                echo "ERROR: Claude Code failed to start after retry. Manual intervention needed."
                exit 1
            fi
        fi
    done

    # Restore original pane width if it was widened
    if [[ -n "$ORIG_WIDTH" ]] && (( ORIG_WIDTH < 200 )); then
        tmux resize-pane -t "$TARGET" -x "$ORIG_WIDTH" 2>/dev/null || true
    fi
fi

echo "Done."
