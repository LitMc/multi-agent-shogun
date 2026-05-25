---
name: atomic-paired-revert-pr-workflow
description: 2 リポジトリ連動の変更 (例: <MODPACK_REPO> クライアント + <SERVER_REPO> サーバ設定) を atomic に revert する手順 template。片方のみ revert merge は厳禁 (data version 不整合で本番停止)、Release draft 化 → 両 revert PR squash merge → build-release.yml auto re-publish 監視 → 本番健全性確認の一気通貫。cmd_346 (<MODPACK_REPO> PR #6 + <SERVER_REPO> PR #3 で確立) の組織知。MC メジャー更新の緊急ロールバック、または同種の 2 リポ連動 revert (modpack/server, client/backend, frontend/api 等) で trigger。
---

# Atomic Paired Revert PR Workflow

## §1 目的と trigger 条件

### 目的

2 つのリポジトリにまたがる連動変更 (例: クライアント modpack + サーバ config/scripts) を、片方先行 merge による不整合を避けつつ revert する手順を template 化する。

- **片方のみ revert** は data version 不整合や接続不可を招く (例: server を旧 version に戻したが modpack は新 version 仕様で配布継続 → クライアント接続不能)
- **両方 revert** は技術的には独立した PR だが、**Release 配布の停止**と**マージ順序**を制御することで実質 atomic にする

### trigger 条件 (このスキルを使うべき状況)

以下に該当する revert を実施する局面で起動する。

- **MC メジャー更新の緊急ロールバック**: `<MODPACK_REPO>` + `<SERVER_REPO>` を一括で前 version に戻す (cmd_346 ケース)
- **同型の連動 revert**: 2 リポジトリにまたがるバージョン変更を atomic に巻き戻す必要がある場面
- **片方 merge 済の中断状態 (= Phase B 完了 / Phase C 未完了)** の継続復旧

### 前提

- 両リポジトリで revert 対象の commit SHA を確定していること
- 配布物 (Release latest 等) が存在すること (Phase A の対象)
- 両リポ main へ push 可能な権限を保持していること

### 適用範囲

本スキルは「**両 PR が連動した revert を必要とする**」場面に限定する。単一リポの revert には `git revert + gh pr create + gh pr merge --squash` の標準フローで十分。

## §2 Phase A: Release draft 化 (配布即時停止)

### 目的

家族・知人・外部利用者が**問題のある配布物を引き続き pull するのを即時阻止**する。Phase B/C の revert merge 完了まで public 配布を止める一時的緊急停止策。

### 手順

```bash
# Release latest を draft 化 (例: <MODPACK_REPO>)
gh release edit latest --draft -R <YOUR_GH_ORG>/<MODPACK_REPO>

# 配布物 public URL が 401/404 になることを検証
curl -sI https://github.com/<YOUR_GH_ORG>/<MODPACK_REPO>/releases/download/latest/<MODPACK_ASSET_NAME>.mrpack
# → HTTP/2 401 (auth required) or 404 (not found) を確認
```

### 検証

- `gh release view latest -R <org>/<repo> --json isDraft` → `isDraft: true`
- `curl -sI <asset_url>` → HTTP 401/404
- 直後の timestamp + curl 出力を PR description / 報告書に証跡として残す

### STOP 条件

- `gh release edit` 自体が失敗 (権限不足、Release 不在) → 即時 STOP、家老へ escalate

## §3 Phase B / Phase C: 両リポ revert PR (起票 + squash merge)

### 順序 (重要)

**配布物影響が大きい側を先**に revert する。MC のケースでは modpack (クライアント配布) → server (サーバ config) の順。両者の dependency を見て決定する。

### Phase B (例: <MODPACK_REPO>)

```bash
# 1. branch 作成
git checkout main
git pull origin main
git checkout -b revert/cmd_XXX-modpack-rollback

# 2. 対象 commit を revert (--no-edit で commit message を自動生成、後で amend で Why/How 追記)
git revert <commit_sha> --no-edit

# 3. commit message に Why/How を amend
git commit --amend  # editor で Why (Paper 未リリース等) + How (Phase A draft 化 + 両リポ revert) を明記

# 4. push + PR open
git push -u origin revert/cmd_XXX-modpack-rollback
gh pr create --title "revert(cmd_XXX): ..." --body "..."

# 5. CI 待機
gh pr checks <pr_number> --watch

# 6. squash merge (branch 自動削除)
gh pr merge <pr_number> --squash --delete-branch
```

### Phase C (例: <SERVER_REPO>) — Phase B 完了直後に実施

```bash
git checkout main
git pull origin main
git checkout -b revert/cmd_XXX-server-rollback
git revert <commit_sha> --no-edit
git commit --amend  # Why/How 明記
git push -u origin revert/cmd_XXX-server-rollback
gh pr create --title "revert(cmd_XXX): ..." --body "..."
gh pr checks <pr_number> --watch
gh pr merge <pr_number> --squash --delete-branch
```

### CI permissions 注意

`<SERVER_REPO>` の `ci.yml` に `permissions: contents:read + pull-requests:read` (cmd_344 由来) が定義済の場合、revert PR が `paths-filter` の `pull-requests:read` を必要とすることがある。conflict 発生時は permissions ブロックを**保持**する方向で resolve すること (削除厳禁)。

### PR description の必須項目

両 PR description に以下を必ず含める。

- Why (revert 理由: e.g., Paper 26.1.2 build 未公開で setup.sh 失敗)
- How (Phase A draft 化済 + 両リポ revert で復旧)
- 元 PR への参照 (`Reverts #N (commit_sha)`)
- 検証手順 (Phase D で確認する項目)

## §4 Phase D: build-release.yml auto re-publish 監視 + 本番健全性確認

### build-release.yml auto re-publish (modpack 側)

modpack 側 revert PR を squash merge した時点で `build-release.yml` が auto-trigger する。

```bash
# 直後の workflow run ID を取得
gh run list --workflow=build-release.yml -R <org>/<repo> --limit 1

# watch (foreground)
gh run watch <run_id> -R <org>/<repo>
```

成功時:
- 新 `.mrpack` (revert 後仕様) が Release latest に auto re-publish
- Release `isDraft: false` に戻る
- 新 `asset_sha256` が古い (問題のある) `.mrpack` と異なることを確認

### deploy.yml 監視 (server 側)

server 側 revert PR の squash merge 直後に `deploy.yml` が auto-trigger する。

```bash
gh run list --workflow=deploy.yml -R <org>/<repo> --limit 1
gh run watch <run_id> -R <org>/<repo>
```

成功時:
- `scripts/` `bot/` `dashboard/` 等の rsync 完了
- `<MC_BOT_UNIT>` / `<MC_DASH_UNIT>` の `Restart services` step SUCCESS
- (minecraft service 本体は無干渉なのが正常。setup.sh は再実行しない)

### 本番 ssh 健全性確認

```bash
ssh -i ~/.ssh/<key> ubuntu@<server_ip> '
  systemctl is-active <MC_UNIT> <MC_BOT_UNIT> <MC_DASH_UNIT>
  ls -la /opt/minecraft/server.jar
  journalctl -u minecraft --since "5 minutes ago" \
    | grep -E "IncompatibleException|Could not migrate|unknown DataVersion|refusing to load|FATAL|java.lang.Error" \
    || echo "data version integrity grep: zero hits"
'
```

期待結果:
- `<MC_UNIT> = active`, `<MC_BOT_UNIT> = active`, `<MC_DASH_UNIT> = active`
- `server.jar` が revert 後の version に対応するサイズ (例: `54MB` for Paper 1.21.11)
- data version integrity grep が**ゼロヒット**

### 配布物整合性確認

```bash
# Release latest の新 asset_sha256 を取得
gh release view latest -R <org>/<repo> --json assets

# 旧 (問題のある) sha256 と異なることを確認
# 新 asset が revert 後仕様であることを内部目視確認
```

## §5 STOP 条件

| Phase | 検知事象 | アクション |
|-------|---------|-----------|
| Phase A | `gh release edit --draft` 失敗 (権限不足、Release 不在) | STOP、escalate |
| Phase B | CI FAIL (markdownlint/shellcheck/unit-tests 等) | STOP、CI ログ確認 → 修正 PR か escalate |
| Phase B | merge 失敗 (conflict / mergeStateStatus=BLOCKED) | STOP、conflict resolve または escalate |
| Phase B/C 間 | Phase B 完了済 / Phase C 未着手の中断 | 即時 Phase C 再開 (中断時間が長引くと家族・知人の接続リスク) |
| Phase C | CI FAIL | STOP、**modpack は既 revert 済** = 配布物は安全だが server-modpack 不整合状態。escalate 優先度高 |
| Phase D | `build-release.yml` FAIL | STOP、Release latest が draft のまま残る = 配布停止状態、escalate |
| Phase D | `deploy.yml` FAIL | STOP、本番 service 設定が古いまま、escalate |
| Phase D | journalctl に data version 不整合検出 | STOP、ロールバック手順書 (`/tmp/cmd_341_phase5_production_apply.md` §A 相当) で server.jar mv 復元 |
| 全 Phase | revert 対象 SHA が間違っている / 期待 diff と異なる | STOP、SHA 再確認 |

## §6 成功事例: cmd_346 (<MODPACK_REPO> + <SERVER_REPO> 26.1.2 → 1.21.11 緊急 revert)

### 経緯 (2026-05-11)

cmd_341 で `1.21.11 → 26.1.2` 仕様を両リポ main にマージしたが、Paper 26.1.2 build 未公開のため本番停止 + subtask_341e ロールバック実施。残課題として「main の 26.1.2 仕様」と「本番の 1.21.11 仕様」が乖離した状態を cmd_346 で atomic に解消した。

### Phase A 実行

```bash
gh release edit latest --draft -R <YOUR_GH_ORG>/<MODPACK_REPO>  # 2026-05-11T10:44:48Z
curl -sI https://github.com/<YOUR_GH_ORG>/<MODPACK_REPO>/releases/download/latest/<MODPACK_ASSET_NAME>.mrpack
# → HTTP/2 404 確認 (2026-05-11T10:45:10Z)
```

### Phase B 実行 (<MODPACK_REPO> PR #6)

- branch: `revert/cmd_346-modpack-rollback`
- revert 対象: PR #5 squash merge commit `<ORIG_COMMIT_SHA_MODPACK>`
- CI: `unit-tests SUCCESS`, `mergeStateStatus=CLEAN`
- squash merge: SHA=`<REVERT_COMMIT_SHA_MODPACK>` (2026-05-11T10:47:08Z)
- branch 自動削除済

### Phase C 実行 (<SERVER_REPO> PR #3)

- branch: `revert/cmd_346-server-rollback`
- revert 対象: PR #1 squash merge commit `<ORIG_COMMIT_SHA_SERVER>`
- CI: 3 SUCCESS (markdownlint / shellcheck / changes) + 2 SKIPPED (python-lint / yaml-validate, paths-filter 正常分岐)
- squash merge: SHA=`<REVERT_COMMIT_SHA_SERVER>` (2026-05-11T10:49:30Z)
- branch 自動削除済
- `ci.yml` の cmd_344 由来 permissions ブロック: conflict ゼロで保持

### Phase D 実行

build-release.yml auto re-publish:
- workflow run `<WORKFLOW_RUN_ID_BUILD>` SUCCESS
- 新 `.mrpack` (sha256=`<MRPACK_SHA256_NEW>`, 1841 bytes) を Release latest に publish (2026-05-11T10:47:31Z)
- 旧 `.mrpack` (sha256=`<MRPACK_SHA256_OLD>`, 26.1.2 仕様) を置換

deploy.yml:
- workflow run `<WORKFLOW_RUN_ID_DEPLOY>` SUCCESS
- `scripts/` + `bot/` + `dashboard/` + `config/` rsync 成功
- `<MC_BOT_UNIT>` / `<MC_DASH_UNIT>` restart 成功 (Bot Discord login 確認)
- `<MC_UNIT>` service 本体は無干渉 (`ActiveEnterTimestamp=2026-05-09 16:03:21 JST` 継続)

本番 ssh 健全性:
- `<MC_UNIT> / <MC_BOT_UNIT> / <MC_DASH_UNIT>` 全 active
- `server.jar`: `54MB Paper 1.21.11-69-main@<BUILD_REF> (Mar 4 23:22 build)`
- journalctl grep `'IncompatibleException|Could not migrate|unknown DataVersion|refusing to load|FATAL|java.lang.Error'` → ゼロヒット
- world 214M 不変

### 結果

| 対象 | revert 前 | revert 後 |
|------|----------|----------|
| 本番 OCI minecraft | 1.21.11 active (subtask_341e ロールバック由来) | 1.21.11 active (継続) |
| <MODPACK_REPO> main | 26.1.2 仕様 | 1.21.11 仕様 |
| <MODPACK_REPO> Release latest .mrpack | 26.1.2 仕様 (配布 NG) | 1.21.11 仕様 (本番整合) |
| <SERVER_REPO> main | 26.1.2 仕様 | 1.21.11 仕様 |

家族・知人プレイヤーが新 `.mrpack` を pull しても 1.21.11 仕様取得で接続可能な完全整合状態に復旧。

## §7 関連 Skill

- **`paper-api-existence-check`**: 本スキル発動の**原因**となる「対象 version build 未公開」を**起票前**に検出するチェックリスト。MC メジャー更新 cmd 起票時に上流で起動し、本スキルが必要な事態を未然に防ぐ。両スキルは MC メジャー更新の **上流 (事前検証)** と **下流 (緊急 revert)** を担う相補関係。

## §8 改訂履歴

| 日付 | cmd | 改訂内容 | Why | How |
|------|-----|----------|-----|-----|
| 2026-05-12 | cmd_347 / subtask_347a | 初版作成 | 2 リポジトリ連動 revert は data version 不整合や接続不可を招くリスクが高く、cmd_346 で確立した workflow を再利用可能な template として恒久資産化する | (1) `.claude/skills/atomic-paired-revert-pr-workflow/SKILL.md` 新規作成 (2) Phase A-D の手順 + STOP 条件を機械化 (3) §6 で cmd_346 の SHA / workflow run ID / 検証結果を再現可能粒度で記載 (4) `paper-api-existence-check` と相補関係を明記 |
| 2026-05-12 | cmd_348 / subtask_348a (v1.1) | Anthropic Skill 標準準拠の kebab-case 統一 | 殿御裁可 Q347-002 採択 (Anthropic 標準 recover-agent / update-config 等は kebab-case ゆえ Skill 命名規約を統一) | (1) ディレクトリ kebab mv rename (2) frontmatter `name` を kebab-case に更新 (3) §7 関連 Skill 内 `paper-api-existence-check` 参照を kebab-case 表記に更新 |
