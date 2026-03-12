#!/usr/bin/env bash
# agent_watchdog.sh — エージェントフリーズ自動検知・復旧スクリプト
# フリーズ（CPU>=95% かつ stat=R+ が連続2回）を検知し、
# agent_kill.sh → 再起動 → inbox nudge → ntfy報告 を自動化する。
#
# 起動方法:
#   bash scripts/agent_watchdog.sh &
#
# ログ: logs/agent_watchdog.log

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$SCRIPT_DIR"

mkdir -p logs

LOG="logs/agent_watchdog.log"
INTERVAL=60
FREEZE_THRESHOLD=95
FREEZE_COUNT_LIMIT=2
COOLDOWN=300  # 復旧後5分間スキップ

SESSION="multiagent"

# 監視対象エージェント
AGENTS="karo ashigaru1 ashigaru2 ashigaru3 ashigaru4 ashigaru5 ashigaru6 ashigaru7 gunshi"

# Agent-to-pane mapping (each agent = own window, pane 0)
get_pane() {
    case "$1" in
        karo|ashigaru[1-7]|gunshi) echo "$1.0" ;;
        *) echo "" ;;
    esac
}

# bash 3.x compatible state management using temp files
STATE_DIR=$(mktemp -d)
trap 'rm -rf "$STATE_DIR"' EXIT

get_freeze_count() {
    local agent="$1"
    local f="$STATE_DIR/freeze_${agent}"
    if [[ -f "$f" ]]; then cat "$f"; else echo 0; fi
}

set_freeze_count() {
    local agent="$1" val="$2"
    echo "$val" > "$STATE_DIR/freeze_${agent}"
}

get_last_recovery() {
    local agent="$1"
    local f="$STATE_DIR/recovery_${agent}"
    if [[ -f "$f" ]]; then cat "$f"; else echo 0; fi
}

set_last_recovery() {
    local agent="$1" val="$2"
    echo "$val" > "$STATE_DIR/recovery_${agent}"
}

log_msg() {
    local level="$1" msg="$2"
    echo "[$(date '+%Y-%m-%dT%H:%M:%S')] [$level] $msg" >> "$LOG"
}

log_msg "INFO" "agent_watchdog.sh 起動。監視間隔=${INTERVAL}秒"

while true; do
    NOW=$(date +%s)

    for agent in $AGENTS; do
        PANE="$(get_pane "$agent")"
        TARGET="${SESSION}:${PANE}"

        # クールダウンチェック
        LAST_REC=$(get_last_recovery "$agent")
        ELAPSED=$(( NOW - LAST_REC ))
        if [[ $ELAPSED -lt $COOLDOWN ]]; then
            continue
        fi

        # ペインのシェルPID取得
        SHELL_PID=$(tmux display-message -t "$TARGET" -p '#{pane_pid}' 2>/dev/null) || continue

        # claudeプロセス取得
        CLAUDE_PID=$(pgrep -P "$SHELL_PID" -f "claude" 2>/dev/null | head -1) || true
        if [[ -z "$CLAUDE_PID" ]]; then
            # claudeが動いていなければカウントリセット
            set_freeze_count "$agent" 0
            continue
        fi

        # CPU使用率取得（整数部分のみ）
        CPU_RAW=$(ps -o %cpu= -p "$CLAUDE_PID" 2>/dev/null) || { set_freeze_count "$agent" 0; continue; }
        CPU_INT=${CPU_RAW%%.*}
        CPU_INT=${CPU_INT// /}
        if [[ -z "$CPU_INT" ]]; then
            set_freeze_count "$agent" 0
            continue
        fi

        # プロセスステータス取得
        STAT=$(ps -o stat= -p "$CLAUDE_PID" 2>/dev/null) || { set_freeze_count "$agent" 0; continue; }
        STAT="${STAT// /}"

        # フリーズ判定: CPU >= 95% かつ stat に R が含まれる
        if [[ "$CPU_INT" -ge "$FREEZE_THRESHOLD" ]] && [[ "$STAT" == *R* ]]; then
            COUNT=$(get_freeze_count "$agent")
            COUNT=$(( COUNT + 1 ))
            set_freeze_count "$agent" "$COUNT"

            if [[ $COUNT -lt $FREEZE_COUNT_LIMIT ]]; then
                log_msg "WARN" "${agent}: CPU=${CPU_INT}% stat=${STAT} (count=${COUNT}/${FREEZE_COUNT_LIMIT})"
            else
                log_msg "ALERT" "${agent}: フリーズ確定。復旧開始"

                # 復旧アクション
                bash scripts/agent_kill.sh "$agent" --restart >> "$LOG" 2>&1 || {
                    log_msg "ERROR" "${agent}: agent_kill.sh 失敗"
                    set_freeze_count "$agent" 0
                    continue
                }

                sleep 5

                bash scripts/inbox_write.sh "$agent" "inbox1" nudge watchdog >> "$LOG" 2>&1 || true

                bash scripts/ntfy.sh "🔄 ${agent}自動復旧完了(CPU100%フリーズ→kill→再起動)" shogun >> "$LOG" 2>&1 || true

                log_msg "INFO" "${agent}: 復旧完了。次回チェック除外: ${COOLDOWN}秒間"

                set_freeze_count "$agent" 0
                set_last_recovery "$agent" "$(date +%s)"
            fi
        else
            # フリーズ条件を満たさない場合はカウントリセット
            set_freeze_count "$agent" 0
        fi
    done

    sleep "$INTERVAL"
done
