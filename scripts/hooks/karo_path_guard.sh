#!/usr/bin/env bash
# karo_path_guard.sh — PreToolUse hook: F001再発防止
# KaroがProject外パスのファイルをEdit/Write/Bashで変更するのをブロック。
# 他エージェント(ashigaru/gunshi/shogun)は影響なし。
set -euo pipefail

INPUT=$(cat)

# エージェント識別
if [ -n "${TMUX_PANE:-}" ]; then
    AGENT_ID=$(tmux display-message -t "$TMUX_PANE" -p '#{@agent_id}' 2>/dev/null || true)
else
    AGENT_ID=""
fi

# karo以外はスルー
if [ "$AGENT_ID" != "karo" ]; then
    exit 0
fi

# プロジェクトルート定義
PROJECT_DIR="/Users/jgoto/multi-agent-shogun"

# ツール名取得
TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_name',''))" 2>/dev/null || echo "")

# Edit / Write チェック
if [ "$TOOL_NAME" = "Edit" ] || [ "$TOOL_NAME" = "Write" ]; then
    FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json, os
data = json.load(sys.stdin)
fp = data.get('tool_input', {}).get('file_path', '')
print(os.path.realpath(fp) if fp else '')
" 2>/dev/null || echo "")

    if [ -n "$FILE_PATH" ]; then
        case "$FILE_PATH" in
            "${PROJECT_DIR}"/*|/tmp/*)
                exit 0
                ;;
            *)
                echo "F001違反防止: karoはproject外パスのファイルを直接変更できません。対象: ${FILE_PATH} — 足軽にタスクYAMLを書いて委譲してください。" >&2
                exit 2
                ;;
        esac
    fi
    exit 0
fi

# Bash チェック
if [ "$TOOL_NAME" = "Bash" ]; then
    COMMAND=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")

    if [ -z "$COMMAND" ]; then
        exit 0
    fi

    export _KARO_CMD="$COMMAND"
    export _KARO_PROJ="$PROJECT_DIR"

    python3 << 'PYEOF'
import sys, re, os

command = os.environ.get('_KARO_CMD', '')
project_dir = os.environ.get('_KARO_PROJ', '/Users/jgoto/multi-agent-shogun')
home_dir = os.path.expanduser('~')

readonly_patterns = [
    r'^(cat|head|tail|less|more|wc|file|stat|ls|tree|find|grep|rg|ag|ack)\b',
    r'^git\s+(log|diff|status|show|branch|remote|tag|rev-parse|describe|shortlog)\b',
    r'^(pwd|echo|printf|date|which|type|command|realpath|dirname|basename)\b',
    r'^tmux\s+(display-message|capture-pane|list-panes|list-sessions|list-windows)\b',
]

write_patterns = [
    r'\b(sed\s+-i|awk\s+-i)\b',
    r'\bgit\s+(add|commit|push|merge|rebase|checkout\s+-b|restore|reset|cherry-pick|am|apply)\b',
    r'\b(npm|pnpm|yarn|pip|uv)\s+(install|add|remove|update)\b',
    r'\b(mkdir|touch|rm|chmod|chown)\b',
    r'(>>?|>\|?)\s*/(?!tmp|dev/null)',
    r'\btee\s+[^|]',
]

# cdコマンドチェック
cd_match = re.search(r'(?:^|;|\s&&\s)cd\s+([^\s;&|]+)', command)
if cd_match:
    cd_target = cd_match.group(1).strip()
    if cd_target.startswith('~'):
        cd_target = home_dir + cd_target[1:]
    cd_target = os.path.realpath(cd_target)
    if not cd_target.startswith(project_dir) and not cd_target.startswith('/tmp'):
        for wp in write_patterns:
            if re.search(wp, command):
                msg = f'F001違反防止: karoはproject外でのファイル変更操作を実行できません。cd先: {cd_target} — 足軽に委譲してください。'
                print(msg, file=sys.stderr)
                sys.exit(2)

# git -C パターン
git_c_match = re.search(r'git\s+-C\s+([^\s]+)', command)
if git_c_match:
    git_target = os.path.realpath(os.path.expanduser(git_c_match.group(1)))
    if not git_target.startswith(project_dir) and not git_target.startswith('/tmp'):
        write_git = re.search(r'\bgit\s+(?:-C\s+\S+\s+)?(add|commit|push|merge|rebase|restore|reset)\b', command)
        if write_git:
            msg = f'F001違反防止: karoはproject外リポジトリへの書込みgit操作を実行できません。対象: {git_target} — 足軽に委譲してください。'
            print(msg, file=sys.stderr)
            sys.exit(2)

# 外部絶対パスへの書込みチェック
external_paths = re.findall(r'(?:' + re.escape(home_dir) + r'|/Users/\w+)/\S+', command)
for ep in external_paths:
    ep_clean = ep.rstrip("'\"`)};")
    real_ep = os.path.realpath(ep_clean)
    if not real_ep.startswith(project_dir) and not real_ep.startswith('/tmp'):
        # read-onlyコマンドは許可（先頭マッチ）
        is_readonly = any(re.match(rp, command.strip()) for rp in readonly_patterns)
        if not is_readonly:
            # 複合コマンド中のread-only動詞チェック（cat, grep等がコマンド内に存在する場合）
            readonly_verbs = ['cat', 'head', 'tail', 'grep', 'less', 'wc', 'ls', 'file', 'stat', 'find', 'tree', 'rg', 'ag', 'ack']
            for tok in command.strip().split():
                if tok in readonly_verbs:
                    is_readonly = True
                    break
        if not is_readonly:
            # 外部パスが書込みリダイレクトのターゲットかを確認
            is_write_redirect = bool(re.search(r'(?:>>?|>\|?)\s*' + re.escape(ep_clean), command))
            if not is_write_redirect:
                # パスがリダイレクト先ではない＝引数として使われている → read目的と推定
                continue
            for wp in write_patterns:
                if re.search(wp, command):
                    msg = f'F001違反防止: karoはproject外パスへの書込みを実行できません。対象: {real_ep} — 足軽に委譲してください。'
                    print(msg, file=sys.stderr)
                    sys.exit(2)

sys.exit(0)
PYEOF
    BASH_EXIT=$?
    exit $BASH_EXIT
fi

exit 0
