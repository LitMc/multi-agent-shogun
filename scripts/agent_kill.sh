#!/usr/bin/env bash
# agent_kill.sh — Kill and optionally restart a Claude Code agent in a tmux pane
# Usage: bash scripts/agent_kill.sh <agent_id> [--restart]
#
# Safety: Only kills claude processes that are direct children of the target
# tmux pane's shell. Will NOT kill arbitrary processes.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SESSION="multiagent"

# Agent-to-pane mapping (compatible with bash 3.x on macOS)
get_pane() {
    case "$1" in
        karo)      echo "0.0" ;;
        ashigaru1) echo "0.1" ;;
        ashigaru2) echo "0.2" ;;
        ashigaru3) echo "0.3" ;;
        ashigaru4) echo "0.4" ;;
        ashigaru5) echo "0.5" ;;
        ashigaru6) echo "0.6" ;;
        ashigaru7) echo "0.7" ;;
        gunshi)    echo "0.8" ;;
        *)         echo "" ;;
    esac
}

usage() {
    echo "Usage: $0 <agent_id> [--restart]"
    echo "  agent_id: karo, ashigaru1-7, gunshi"
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
PANE="$(get_pane "$AGENT_ID")"
if [[ -z "$PANE" ]]; then
    echo "ERROR: Unknown agent_id: $AGENT_ID"
    echo "Valid agents: karo, ashigaru1-7, gunshi"
    exit 1
fi

TARGET="${SESSION}:${PANE}"

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
        tmux send-keys -t "$TARGET" "claude --model opus --dangerously-skip-permissions" Enter
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
    tmux send-keys -t "$TARGET" "claude --model opus --dangerously-skip-permissions" Enter
    echo "Restart command sent. Agent should recover via /clear protocol."
fi

echo "Done."
