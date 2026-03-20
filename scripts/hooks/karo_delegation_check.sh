#!/usr/bin/env bash
# karo_delegation_check.sh — Stop hook補助: 委譲チェック
set -euo pipefail

INPUT=$(cat)

if [ -n "${TMUX_PANE:-}" ]; then
    AGENT_ID=$(tmux display-message -t "$TMUX_PANE" -p '#{@agent_id}' 2>/dev/null || true)
else
    exit 0
fi
[ "$AGENT_ID" != "karo" ] && exit 0

STOP_HOOK_ACTIVE=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('stop_hook_active', False))" 2>/dev/null || echo "False")
[ "$STOP_HOOK_ACTIVE" = "True" ] && exit 0

TRANSCRIPT=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('transcript_path', ''))" 2>/dev/null || echo "")

if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
    DELEGATION_COUNT=$(grep -c 'inbox_write.sh.*ashigaru' "$TRANSCRIPT" 2>/dev/null || echo "0")
    if [ "$DELEGATION_COUNT" -eq 0 ]; then
        python3 -c "
import json
print(json.dumps({
    'hookSpecificOutput': {
        'hookEventName': 'Stop',
        'additionalContext': '⚠️ F001注意: このセッションで足軽への委譲(inbox_write ashigaru)が検出されませんでした。実装作業を自分で行っていませんか？実装は足軽に委譲してください。'
    }
}, ensure_ascii=False))
"
    fi
fi

exit 0
