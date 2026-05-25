---
name: parallel-worktree-coordination
description: 同一 repo で複数足軽が並走する cmd において git worktree 戦略を必須化、HEAD 共有による git switch 競合・編集紛れ込み事故を根絶する Skill。cmd 起票時に並走を検知したら本 Skill を invoke し worktree path 事前定義 + 4 Step (git worktree add -b / 各 worktree 独立作業 / pnpm install 等 worktree 毎 / 家老 squash merge 後 git worktree remove) を task description に含める。cmd_362/363 同時並走の HEAD 競合事案 (家老連続前提誤認 9 件目、ashigaru4 textbook 5 例目) で確立した組織知。同一 repo で 2 名以上の足軽が並走する cmd を起票する局面で trigger する。
---

# Parallel Worktree Coordination

## §1 目的と trigger 条件

### 目的

同一 repo (例: `$HOME/ghq/github.com/<YOUR_GH_ORG>/<APP_REPO>`) で複数足軽が並走する cmd において、git worktree 戦略を必須化し、HEAD 共有による `git switch` 競合 + 編集紛れ込み事故を根絶する。memory MCP entity「家老_PR状態事前確認ルール」に既記録の運用ルール (cmd_362/363 並走事案由来、2026-05-22) を Claude Code Skill 機構で LLM 自動 surface 可能にする 5 番目 skill として恒久資産化する。

git HEAD は repo 単位ゆえ、単一 working tree で複数足軽が `git switch` を同時実行すると、片方の編集が他方の working tree に紛れ込む事故が発生する (cmd_362/363 で実機観測済)。worktree は git 純正機構で安全 + ディスクコスト (node_modules 重複) は許容範囲、本 Skill で運用 template 化する。

### trigger 条件 (この Skill を使うべき状況)

以下のいずれかに該当する局面で起動する。

- 同一 repo (例: <APP_REPO> / multi-agent-shogun / <MODPACK_REPO>) で 2 名以上の足軽が並走する cmd を起票する時
- 既に並走配分で `git switch` HEAD 競合・編集紛れ込みが発生し、復旧フローが必要な時
- 家老が cmd 起票時に「並走配分」「ashigaru3 + ashigaru4」「同一 repo」等の文言を含む task description を draft している時

### 前提

- 並走対象の足軽数 + 各足軽の作業範囲 (feat ブランチ名) が確定していること
- 親 repo の clone 済 path が確定していること (例: `$HOME/ghq/github.com/<YOUR_GH_ORG>/<APP_REPO>`)
- worktree 配置先 (親 repo 兄弟ディレクトリ) のディスク容量に余裕があること (node_modules 重複ぶん)
- 各足軽が `git worktree add` + `pnpm install` を実行可能な権限を保持していること

### 適用範囲

本 Skill は「**同一 repo で 2 名以上の足軽が並走する cmd**」に限定する。**単独足軽の cmd は本 Skill 不要** (通常 working tree で OK)。異なる repo にまたがる並走 (例: cmd_366 multi-agent-shogun + cmd_364 <APP_REPO>) は repo 単位で HEAD が独立するため本 Skill 対象外。

## §2 4 Step 一気通貫手順

各 Step に「目的」「操作」「検証」「STOP 条件」を併記する。所要時間目安は cmd_362/363 並走事案実測 (worktree 案承認 → 復旧 → 完遂) で 5-10 分 / 足軽 (worktree 作成 + pnpm install 含む、復旧 phase の patch 退避を除く)。

### Step 1: worktree path 事前定義

#### 目的

並走足軽の数だけ worktree path を事前定義し、task description に明記することで、各足軽が割り当て path 内のみで作業する境界を成立させる。

#### 操作 (家老による task description 起票時に明示)

- 並走足軽の数だけ worktree path を事前定義 (例: `<APP_REPO>-cmd362` / `<APP_REPO>-cmd363`)
- 親 repo path 直下兄弟ディレクトリとして配置 (例: `$HOME/ghq/github.com/<YOUR_GH_ORG>/<APP_REPO>-cmd362`)
- task description Phase 1 で worktree path + feat ブランチ名を pair で明示

```
ashigaru3 worktree: ../<APP_REPO>-cmd362 (feat/cmd_362-tips-tablecell)
ashigaru4 worktree: ../<APP_REPO>-cmd363 (feat/cmd_363-tips-highlight-wrap)
```

#### 検証

- 各足軽が割り当て path を task description 内で目視確認できること
- path 衝突がないこと (兄弟ディレクトリ命名が unique)

#### STOP 条件

- worktree path 配置先に既存ファイル/ディレクトリが存在 → 家老 escalate、別名割り当て
- 並走足軽数が 3 名以上で worktree 配置先ディスク容量が不足 → 家老判断 (並走縮小 or worktree 配置先変更)

### Step 2: git worktree add -b コマンド明示

#### 目的

各足軽が自分の worktree path 内で独立した HEAD を保持できる状態を成立させる。base ブランチ (`origin/main`) からの新規 feat ブランチを worktree 内で切り、HEAD 共有による競合根絶を実現する。

#### 操作 (各足軽が自分の worktree 作成時に実行)

```bash
cd $HOME/ghq/github.com/<YOUR_GH_ORG>/<APP_REPO>  # 親 repo
git fetch origin
git worktree add -b feat/cmd_<id>-<feature> ../<APP_REPO>-cmd<id> origin/main
cd ../<APP_REPO>-cmd<id>  # 以降 worktree 内で作業
git branch --show-current  # feat/cmd_<id>-<feature> 確認
```

- **base ブランチを明示** (`origin/main` を base とし、既存 feat ブランチを再利用しない)
- 各足軽は割り当て worktree path 内で作業、`git switch` を親 repo で実行しない (HEAD 共有による競合根絶)

#### 検証

- `git worktree list` で 親 repo + 各足軽 worktree が一覧表示
- 各 worktree 内で `git branch --show-current` が割り当て feat ブランチを返す
- 親 repo の HEAD は base ブランチ (例: main) のまま不変

#### STOP 条件

- `git worktree add` が同 branch 既 checkout エラー (例: `branch is already checked out`) → 別 worktree で同 branch を checkout 済、家老に確認後 worktree 整理 (F358-004 由来)
- `git worktree add` が path 既存エラー → 配置先 ディレクトリ削除 or 別名割り当て

### Step 3: pnpm install 等 worktree 毎独立

#### 目的

worktree は `.git` のみ親 repo 共有、`node_modules` は worktree 毎に別途インストールする必要がある。各 worktree で独立した dev 環境を成立させ、build / test / dev サーバを並走実行可能にする。

#### 操作 (各足軽が自分の worktree 内で実行)

```bash
cd ../<APP_REPO>-cmd<id>  # 自分の worktree
pnpm install          # node_modules を worktree 内に独立配置
pnpm dev              # dev サーバ起動 (port は family 内で衝突しないよう --port 4322 等で分離可)
```

- pnpm / npm / yarn いずれも worktree 内で実行
- ディスクコスト (node_modules 重複) は許容範囲 (typical Node project で数百 MB ~ 1 GB / worktree)
- dev サーバ port は family 内で重複しないよう各足軽 task description で割り当てを明示推奨

#### 検証

- `ls ../<APP_REPO>-cmd<id>/node_modules` で worktree 内 node_modules 存在
- `pnpm dev` が起動成功
- 並走足軽の dev サーバが port 衝突なく同時起動可能

#### STOP 条件

- `pnpm install` が失敗 → Node version (`.node-version` or `.nvmrc`) の確認、`fnm use` 等で固定後リトライ
- dev サーバ port 衝突 → `--port` 明示で分離

### Step 4: 家老 squash merge 後 git worktree remove cleanup

#### 目的

各足軽の作業完了 + 家老 squash merge 後、worktree を削除し親 repo を clean state に戻す。`git worktree remove` + `git branch -d` で安全に cleanup する。

#### 操作 (家老が squash merge 後に実行)

```bash
cd $HOME/ghq/github.com/<YOUR_GH_ORG>/<APP_REPO>  # 親 repo
gh pr merge <pr_number> --squash --delete-branch  # 家老 squash merge (remote branch 自動削除)
# worktree が使用中で branch -d fail することあり、worktree remove を先に実施
git worktree remove ../<APP_REPO>-cmd<id>
git branch -d feat/cmd_<id>-<feature>                  # remote merged 確認後 -d で安全削除
git worktree list                               # 親 repo のみ残存していることを確認
```

- `git worktree remove` で worktree path + .git/worktrees/<name> の管理 metadata を削除
- `git branch -d` (NOT `-D`) で merged 確認後の安全削除 (D004 ABSOLUTE BAN 遵守、`-D` は force 削除ゆえ未 merge 検出を bypass)
- `git push --force-with-lease` (CLAUDE.md Tier 3 SAFE DEFAULTS) を rebase 後 push に使用、`--force` は禁止

#### 検証

- `git worktree list` に親 repo のみ残存
- `git branch` に feat ブランチが残存していないこと
- 親 repo の HEAD が main + clean state

#### STOP 条件

- `git worktree remove` が「worktree is dirty」エラー → 未 commit 変更があり、内容確認後 commit/stash/破棄判断
- `git branch -d` が未 merged エラー → remote merge 状態再確認 (`git log origin/main..feat/cmd_<id>-<feature>` で diff zero 確認)、merge 済なら `-d` で安全削除可能

## §3 注意事項

### HEAD 共有による事故メカニズム

- git HEAD は **repo 単位** ゆえ単一 working tree で複数足軽が `git switch` を同時実行すると、片方の編集が他方の working tree に紛れ込む
- worktree は git 純正機構で安全、Tier 1/2/3 違反なし (D003 force push / D004 reset --hard / D006 kill 等いずれにも該当しない)
- `.git` は親 repo 共有ゆえ pre-push hook 等は worktree でも有効

### rebase 時の log.yaml 衝突対処 (cmd_363 C2 事例)

並走 PR を順次 squash merge する場合、後発 PR の log.yaml に rebase 衝突が発生することがある。cmd_363 C2 事例: PR #15 (cmd_362) merge 後、PR #14 (cmd_363) の log.yaml で `<<<<<<<` 等 conflict marker 発生 → 3 marker 行削除のみで両 entry (cmd_362 approved + cmd_363 approved) 共存解消 → `git push --force-with-lease` (Tier 3 SAFE DEFAULTS 合致) で push 完遂。

### Workers Builds / CI long-poll

worktree 内 push 後の CI 完了監視は `gh pr checks <pr_number> --watch` で blocking 監視可能。Bash tool timeout 5 分指定が family resemblance 運用 (CF Pages build 27 秒 + 余裕 11 倍、agent idle 待機ゆえ追加トークン消費ゼロ、polling loop なし F004 抵触せず)。

### node_modules 重複コスト

worktree 毎に `pnpm install` で node_modules を独立配置するゆえ、ディスクコストは worktree 数倍に膨らむ。Node project の typical sizes (数百 MB ~ 1 GB / worktree) は許容範囲だが、極大 monorepo では `pnpm` の global store 機構が hard link で実コストを縮減するため pnpm 推奨。

## §4 成功事例: cmd_362/363 同時並走 textbook (2026-05-22)

### 経緯

殿御下命 cmd_362 (PR #15 GFM table セル Tips 対応、ashigaru3) + cmd_363 (PR #14 Tips ハイライト折り返し描画修正、ashigaru4) を `$HOME/ghq/github.com/<YOUR_GH_ORG>/<APP_REPO>` 上で並走配分。家老 task description で worktree 戦略を明示せず単一 working tree 前提で起票したため、HEAD 共有による事故が発生。

### 事故発生

ashigaru4 が `git switch -c feat/cmd_363-tips-highlight-wrap origin/main` 直後に、ashigaru3 が `git switch feat/cmd_362-tips-tablecell` を実行 → HEAD が ashigaru3 ブランチに移り、ashigaru4 編集の `public/styles/global.css` が ashigaru3 working tree に紛れ込んだ。

### ashigaru4 Tier 2 STOP-AND-REPORT 復旧 4 step (textbook 5 例目)

1. **即時 STOP** (CLAUDE.md Destructive Operation Safety 範囲外だが「ashigaru3 working tree に編集が紛れ込んだ」異常を STOP-AND-REPORT 級と自己判定)
2. **CSS patch 退避**: `/tmp/cmd_363_css.patch` (468 B) に保存
3. **ashigaru3 working tree から CSS 変更 revert** + dev サーバ停止 + スクラッチ `.cmd_363_*.mjs` 5 本削除 (ashigaru3 の cmd_362 作業 = `remark-tips.mjs` / `test.mjs` / `package.json` / `pnpm-lock.yaml` に副作用ゼロ)
4. **打開案能動提示**: 家老に判断を譲るのではなく `git worktree` 案を具体提示、家老の判断負荷を軽減

### 家老 worktree 案承認 + ashigaru4 再着手

家老が設計ミス (並走時 worktree 事前指示漏れ) を認め、`git worktree add -b feat/cmd_363-tips-highlight-wrap ../<APP_REPO>-cmd363 origin/main` で分離 → patch apply → `pnpm install` → Phase 2-5 完遂を承認。ashigaru3 には git switch 禁止注意喚起。

### 家老 C2 対処 (log.yaml 衝突 rebase 解消)

PR #15 (cmd_362) merge 後 origin/main に cmd_362 entry が反映されたため、PR #14 (cmd_363) の `.<USE_CASE>/log.yaml` に rebase 衝突発生。家老が `../<APP_REPO>-cmd363` worktree 内で `git rebase origin/main` 実行 → 3 marker 行削除のみで両 entry (cmd_362 approved + cmd_363 approved) 共存解消 → `git push --force-with-lease` (CLAUDE.md Tier 3 SAFE DEFAULTS 合致) → Workers Builds CI long-poll (`gh pr checks --watch`、Bash tool timeout 5 分指定) PASS → squash merge → `git worktree remove` + `git branch -d` で cleanup 完遂。

### 完遂結果

| PR | commit | 内容 |
|----|--------|-----|
| PR #15 (cmd_362) | `1f4314f` | GFM table セル Tips 対応 (`src/plugins/remark-tips.mjs`) + ashigaru1 視覚レビュー approved (commit `b7d87c7`) |
| PR #14 (cmd_363) | `1b6f0e8` | Tips ハイライト折り返し描画修正 (`public/styles/global.css` 3 行) + ashigaru1 視覚レビュー approved (commit `8944eaa`) |

両 PR squash merge 完遂、視覚レビュー 4 ok + 1 n/a (interaction static 検証不可)、ライト / ダーク両テーマ box-decoration-break:clone 効果検証 PASS。家老連続前提誤認 9 件目 + ashigaru4 textbook 5 例目 (Tier 2 即時 escalate + 非破壊的 4 step 復旧 + 打開案能動提示 + Phase 2-3 成果透明開示) を memory MCP「家老_PR状態事前確認ルール」entity に記録、本 Skill で恒久資産化。

## §5 関連資産 (相互参照、5 Skill 体系)

### 兄弟 Skill 4 件との関係

| 兄弟 Skill | 役割 | 本 Skill との関係 |
|------------|------|----------------|
| `.claude/skills/paper-api-existence-check/SKILL.md` (cmd_347 由来) | Minecraft major-version 更新 cmd 起票前 Paper API 事前検証 | **兄弟配置** (kebab-case + プロジェクトローカル + frontmatter + § 構成 pattern 共有)、適用領域は独立 (MC update flow) |
| `.claude/skills/atomic-paired-revert-pr-workflow/SKILL.md` (cmd_347 由来) | 2 リポ連動 atomic revert workflow | **兄弟配置** (同上)、適用領域は独立 (MC update flow の下流) |
| `.claude/skills/oci-arm-a1-initial-setup/SKILL.md` (cmd_353 由来、v1.1 cmd_355 改訂) | OCI Ampere A1 (aarch64) + Ubuntu 24.04 初期 6 Phase + cloudflared install + 運用 lessons | **兄弟配置** (同上)、適用領域は独立 (host setup → Tunnel 接続 flow 上流) |
| `.claude/skills/cloudflare-tunnel-route-cname-conflict-recovery/SKILL.md` (cmd_355 由来) | Cloudflare Tunnel route 追加時 CNAME 衝突復旧 4 Step | **兄弟配置** (同上)、適用領域は独立 (host setup → Tunnel 接続 flow 下流) |

### memory MCP entity との役割分担

| 資産 | 役割 | trigger |
|------|------|---------|
| memory MCP entity「家老_PR状態事前確認ルール」(2026-05-22 observation 追加分: 「家老連続前提誤認 9 件目」+ 「同一 repo 並走時 worktree 必須化運用ルール」+ 「ashigaru4 Critical Thinking textbook 5 例目」) | human-facing 運用ルール + 連続前提誤認反省 chain の persistent な session 横断記録 | shogun / karo / gunshi の MCP read_graph 時 |
| 本 Skill `parallel-worktree-coordination` | LLM 自動 surface (Claude Code Skill 機構)、template として再利用 | LLM が「並走配分」「同一 repo」「2 名以上の足軽」等の cmd 文言を検知した時 |

両者は重複ではなく**相互参照**で運用する。本 Skill §4 が memory MCP entity の cmd_362/363 実機データを源泉として援用、memory entity 側は「skill 昇格済」として本 Skill 参照を明示。

### 副次発見 F358-004 (worktree 別運用主素材) との関係

`queue/reports/ashigaru1_report.yaml` の F358-004 副次発見「別 worktree (<APP_REPO>-cmd363) で同 branch checkout 済 = 私の main worktree から switch 不可」は、本 Skill §2 Step 2 STOP 条件 + §3 注意事項 (HEAD 共有事故メカニズム) の主素材として組み込み済。reviewer と reviewee が別 branch / 別 commit を扱う場合 worktree 別運用が必須、各 worktree で independent に log.yaml edit / commit / push 可能。

### 5 Skill 体系 (cmd_347 → cmd_353 → cmd_355 → cmd_366) と workflow chain 3 系統

`.claude/skills/` 配下の Skill 群は cmd_347 で 2 件起票 (paper-api-existence-check + atomic-paired-revert-pr-workflow)、cmd_353 で oci-arm-a1-initial-setup 追加 (3 Skill 体系)、cmd_355 で cloudflare-tunnel-route-cname-conflict-recovery 追加 (4 Skill 体系)、cmd_366 で本 Skill 追加 (5 Skill 体系) で成立。配置 pattern (frontmatter + § 構成 + kebab-case + プロジェクトローカル必須) を共有しつつ、適用領域ごとに 3 系統の workflow chain が確立されている。

- **MC update flow**: `paper-api-existence-check` (起票前事前検証、上流) → `atomic-paired-revert-pr-workflow` (緊急 revert、下流)
- **host setup → Tunnel 接続 flow**: `oci-arm-a1-initial-setup` (Linux host 初期構築 + cloudflared install、上流) → `cloudflare-tunnel-route-cname-conflict-recovery` (Tunnel route CNAME 衝突復旧、下流)
- **並走配分 flow**: 本 Skill `parallel-worktree-coordination` (同一 repo 並走時 worktree 必須化、独立、家老 cmd 起票時 trigger)

## §6 改訂履歴

| 日付 | cmd | 改訂内容 | Why | How |
|------|-----|----------|-----|-----|
| 2026-05-22 | cmd_366 / subtask_366a | 初版作成 (v1.0) | cmd_362/363 同一 repo 並走 working tree 衝突事案 (家老連続前提誤認 9 件目、ashigaru4 textbook 5 例目、2026-05-22 18:41 発生) で確立した運用ルールを Claude Code Skill 機構で LLM 自動 surface 可能にする 5 番目 skill として恒久資産化する。memory MCP entity「家老_PR状態事前確認ルール」既記録の「同一 repo 並走時 worktree 必須化」運用ルールを Skill 昇格し、family resemblance な既存 4 Skill 体系 (paper-api / atomic-paired / oci v1.1 / cf-tunnel) と並ぶ位置付け (殿御裁可 Q362-001=案 a 採択、軍師 msg_20260522_190055 推奨優先度 medium) | (1) `.claude/skills/parallel-worktree-coordination/SKILL.md` 新規作成 (kebab-case + プロジェクトローカル必須、cmd_348 確立配置ルール遵守) (2) §1-§6 標準構成 (cmd_347/353/355 同型 pattern、§4 成功事例 + §5 関連資産 + §6 改訂履歴 family resemblance) (3) §2 で 4 Step (worktree path 事前定義 / git worktree add -b / pnpm install 等 worktree 毎 / 家老 squash merge 後 git worktree remove cleanup) を機械的再現可能粒度で明文化、各 Step に目的 / 操作 / 検証 / STOP 条件を併記 (4) §3 で HEAD 共有事故メカニズム + rebase log.yaml 衝突対処 (cmd_363 C2 事例) + Workers Builds long-poll 運用 + node_modules 重複コスト評価を組み込み (5) §4 で cmd_362/363 並走事案実機経緯 (ashigaru4 Tier 2 STOP-AND-REPORT 復旧 4 step textbook 事例 + 家老 worktree 案承認 + 家老 C2 対処 rebase + force-with-lease push + squash merge + cleanup 完遂) を paraphrase 表現で記載 (6) §5 で 5 Skill 体系 + workflow chain 3 系統を明示、F358-004 (worktree 別運用副次発見、ashigaru1 reviewer 由来) を §2 Step 2 STOP 条件 + §3 注意事項の主素材として組み込み (7) 殿原則 cmd_340 自己完備性体現 (本 Skill 内に未消化先送り表現を含まず自己完結記述、paraphrase rule 拡張適用済) + secrets ゼロ PASS + D003/D004 ABSOLUTE BAN 完全遵守 (本 Skill 起草作業中、force push / reset --hard / clean -f / kill 等使用ゼロ) |
