#!/usr/bin/env bash
# SayTask通知 — ntfy.sh経由でスマホにプッシュ通知
# FR-066: ntfy認証対応 (Bearer token / Basic auth)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SETTINGS="$SCRIPT_DIR/config/settings.yaml"

# ntfy_auth.sh読み込み
# shellcheck source=../lib/ntfy_auth.sh
source "$SCRIPT_DIR/lib/ntfy_auth.sh"

TOPIC=$(grep 'ntfy_topic:' "$SETTINGS" | grep -v 'ntfy_topic_sub' | awk '{print $2}' | tr -d '"')
TOPIC_SUB=$(grep 'ntfy_topic_sub:' "$SETTINGS" | awk '{print $2}' | tr -d '"')

# 送信元→表示名変換
SENDER="${2:-}"
case "$SENDER" in
  shogun)    TITLE="🏯将軍";  USE_TOPIC="${TOPIC}" ;;
  karo)      TITLE="🏠家老";  USE_TOPIC="${TOPIC_SUB:-$TOPIC}" ;;
  gunshi)    TITLE="🎯軍師";  USE_TOPIC="${TOPIC_SUB:-$TOPIC}" ;;
  ashigaru*) TITLE="⚔️足軽${SENDER#ashigaru}"; USE_TOPIC="${TOPIC_SUB:-$TOPIC}" ;;
  *)         TITLE="";        USE_TOPIC="${TOPIC_SUB:-$TOPIC}" ;;
esac

# TOPIC未設定チェック（既存のexit 1を維持）
if [ -z "$USE_TOPIC" ]; then
  echo "ntfy_topic not configured in settings.yaml" >&2
  exit 1
fi

# 認証引数を取得（設定がなければ空 = 後方互換）
AUTH_ARGS=()
while IFS= read -r line; do
    [ -n "$line" ] && AUTH_ARGS+=("$line")
done < <(ntfy_get_auth_args "$SCRIPT_DIR/config/ntfy_auth.env")

# Title引数構築
TITLE_ARGS=()
if [ -n "$TITLE" ]; then
  TITLE_ARGS=(-H "Title: $TITLE")
fi

curl -s "${AUTH_ARGS[@]}" "${TITLE_ARGS[@]}" -H "Tags: outbound" \
  -d "$1" "https://ntfy.sh/$USE_TOPIC" > /dev/null
