---
name: paper-api-existence-check
description: Minecraft major-version 更新 cmd を起票する前に、Paper Project API (https://api.papermc.io/v2/projects/paper/versions/<X.Y.Z>) が対象 version + 非空 builds 配列を返すか curl で事前検証するチェックリスト。HTTP 404 または builds 空配列を検出したら cmd 起票を block すること。cmd_341 (Paper 26.1.2 build 未リリース → setup.sh 失敗 → 本番停止) 失敗の再発防止策で、cmd_346 (両リポ revert + Release draft 化) で復旧確立した組織知。multi-agent-shogun の karo/shogun が MC 更新 cmd を起票する局面で trigger する。
---

# Paper API Existence Check

## §1 目的と trigger 条件

### 目的

Minecraft Java Edition のメジャー version 更新 (例: `1.21.X → 1.22.Y`、または `1.21.X → 26.X.Y`) を計画する cmd を起票する際、Paper Project API 上で対象 version に対応する stable build が**実際に公開されているか**を起票前に確認する。リリース番号は決まっていても build が未公開のことがあり、build 未公開のまま setup.sh を本番で走らせると `Failed to fetch Paper build info` で停止する。

### trigger 条件 (このスキルを使うべき状況)

以下のいずれかに該当する cmd を draft 中なら起動する。

- `<SERVER_REPO>` リポジトリの `setup.sh` で `MINECRAFT_VERSION` を bump する
- `<MODPACK_REPO>` リポジトリで Minecraft target version を変更する
- modpack の `modrinth.index.json` で `minecraft` version を上げる
- 上記いずれかを含む atomic 2-PR (modpack + server) を起票する
- shogun/karo が「Minecraft メジャー更新」「Paper X.Y.Z 移行」等の文言で cmd を draft している

### 前提

- 対象 version `X.Y.Z` (例: `1.21.11`, `1.22.0`, `26.1.2`) を確定していること
- インターネット接続が利用可能 (api.papermc.io への HTTPS GET)

## §2 検証手順

以下 5 ステップを起票本文「事前検証」セクションに証跡 (curl 出力 + timestamp) として残すこと。

### Step 1: Paper version の存在確認

```bash
curl -s -o /dev/null -w "%{http_code}\n" \
  https://api.papermc.io/v2/projects/paper/versions/<X.Y.Z>
```

- **HTTP 200** → 次へ進む
- **HTTP 404** → STOP。対象 version 自体が Paper に登録されていない (=未リリース)。**cmd 起票を block**

### Step 2: builds 配列の非空確認

```bash
curl -s https://api.papermc.io/v2/projects/paper/versions/<X.Y.Z> | jq '.builds | length'
```

- **`>=1`** → 次へ進む
- **`0`** → STOP。version は登録されているが stable build が未公開 (= setup.sh の `getLatestBuild()` が失敗する)。**cmd 起票を block**

### Step 3: 最新 build のメタデータ確認

```bash
curl -s https://api.papermc.io/v2/projects/paper/versions/<X.Y.Z>/builds \
  | jq '.builds[-1] | {build, channel, time, downloads: .downloads.application.name}'
```

- `channel` が `default` または `experimental` であることを確認 (`default` 推奨)
- `downloads.application.name` (例: `paper-1.21.11-69.jar`) が存在すること
- `time` が直近 (= 古過ぎる build を引かない) であること

### Step 4: Modrinth + Fabric Meta API 互換確認 (既存運用)

modpack 同梱 mod 群と Fabric loader の対応関係を Modrinth (`https://api.modrinth.com/v2/...`) および Fabric Meta API (`https://meta.fabricmc.net/v2/...`) で別途確認する。詳細は `context/minecraft-server.md` § 「MC メジャー更新 cmd 起票時の事前検証チェックリスト」項 3 を参照。

### Step 5: 証跡を起票本文に残す

cmd 起票本文 (`queue/shogun_to_karo.yaml` 内 cmd body) に以下 4 点を必ず記載する。

- 検証日時 (UTC + JST)
- Step 1 HTTP status (200/404)
- Step 2 builds 配列長
- Step 3 `build`/`channel`/`time` 抜粋

## §3 失敗事例: cmd_341 (Paper 26.1.2 build 未リリース、本番停止に至る)

### 経緯

- **2026-05-07** cmd_341 起票: Paper `1.21.11 → 26.1.2` メジャー更新、atomic 2-PR (<MODPACK_REPO> + <SERVER_REPO>)、L4 / 4-6h
- **起票時の検証漏れ**: `26.1.2` は Paper 公式アナウンス上で言及されていたが、**実際に builds 配列が公開されていなかった**。Step 2 を実施せずに起票した
- **Phase 5 (本番 apply) 実行時**: subtask_341e の足軽が本番 OCI で `setup.sh -y` を実行 → `Failed to fetch Paper build info` でスクリプト中断
- **影響**: minecraft service 停止 (`ActiveState=failed`)、家族・知人プレイヤー接続不可

### 復旧 (subtask_341e ロールバック)

1. `server.jar.bak.1.21.11.20260509-160122` を `/opt/minecraft/server.jar` に mv で復元 (元 server.jar は touch せず破壊ゼロ)
2. `sudo systemctl start minecraft` → active 確認
3. `journalctl -u minecraft -n 200 | grep -E 'IncompatibleException|Could not migrate'` → ゼロヒット (world 整合性 OK)
4. world データ 214M 不変、再起動後接続正常

### 教訓

- **Step 1 (HTTP 200) だけでは不十分**。Step 2 (builds 配列非空) を必ず実施する
- Paper 公式アナウンスは「version 登録」と「build 公開」が時間差を持つ
- setup.sh の `getLatestBuild()` 失敗は本番停止に直結 (= 起票時 block 価値が極めて高い)

## §4 成功事例: cmd_346 (緊急 revert で 1.21.11 復旧 + 再発防止確立)

### 経緯

- **2026-05-11** cmd_346 起票: cmd_341 で main にマージされた `26.1.2` 仕様を atomic に revert
- **Phase A** (`gh release edit latest --draft -R <YOUR_GH_ORG>/<MODPACK_REPO>`): 家族・知人プレイヤーの `.mrpack` pull を即時阻止。元 public URL → `curl -sI` で HTTP/2 404 確認
- **Phase B** (modpack repo PR #6 revert): commit SHA を `<REVERT_COMMIT_SHA_MODPACK>` で squash merge (2026-05-11T10:47:08Z)
- **Phase C** (server repo PR #3 revert): commit SHA を `<REVERT_COMMIT_SHA_SERVER>` で squash merge (2026-05-11T10:49:30Z)
- **Phase D** (本番健全性確認): `<MC_UNIT> / <MC_BOT_UNIT> / <MC_DASH_UNIT>` 全 active、Paper `1.21.11-69-main@<BUILD_REF>`、journalctl grep ゼロヒット
- **Phase D 副次**: build-release.yml が revert merge で auto-trigger され、新 1.21.11 仕様 `.mrpack` (sha256=`54586dc8...`) を Release latest に publish 復活

### 確立された組織知

1. **本スキル**: Paper API existence check を機械的 surface 化
2. **`context/minecraft-server.md`**: 5 項目チェックリスト (本スキルの human-facing 版、shogun/karo 起票時参照)
3. **atomic-paired-revert-pr-workflow スキル**: 2 リポ連動 revert の手順 template (本スキルと相補的に運用)

## §5 既存資産との関係 (相互参照)

### context/minecraft-server.md との役割分担

| 資産 | 役割 | trigger |
|------|------|---------|
| `context/minecraft-server.md` § 「MC メジャー更新 cmd 起票時の事前検証チェックリスト」 5 項目 | human-facing 起票時参照 | shogun/karo が context として読み込む時 |
| 本スキル `paper-api-existence-check` | LLM 自動 surface (Claude Code Skill 機構) | LLM が「MC メジャー更新」を検知した時 |

両者は重複ではなく**相互参照**で運用する。

- 本スキル §2 検証手順は `context/minecraft-server.md` 同名セクション項 1-3 を機械手順化したもの
- `context/minecraft-server.md` 末尾には本スキルへのリンクを併記 (cmd_347 subtask_347a で追記)

### atomic-paired-revert-pr-workflow との関係

本スキル (事前検証) で block を検出できなかった場合、または block 後の既マージ状態に対する救済策として `atomic-paired-revert-pr-workflow` を使う。両スキルは MC メジャー更新の **上流 (事前検証)** と **下流 (緊急 revert)** を担う。

## §6 改訂履歴

| 日付 | cmd | 改訂内容 | Why | How |
|------|-----|----------|-----|-----|
| 2026-05-12 | cmd_347 / subtask_347a | 初版作成 | cmd_341 (失敗) → cmd_346 (復旧) の組織知を恒久資産化し、Claude Code Skill 機構で LLM 自動 surface 可能にする | (1) `.claude/skills/paper-api-existence-check/SKILL.md` 新規作成 (2) `context/minecraft-server.md` 同名セクションと相互参照成立 (3) §3-§4 で cmd_341 / cmd_346 の Why/How を再現可能粒度で記載 |
| 2026-05-12 | cmd_348 / subtask_348a (v1.1) | Anthropic Skill 標準準拠の kebab-case 統一 + §2 intro 表記 off-by-one 解消 | 殿御裁可 Q347-002 採択 (Anthropic 標準 recover-agent / update-config 等は kebab-case ゆえ Skill 命名規約を統一) + Q347-001 採択 (§2 intro 「4 ステップ」は実 Step 1-5 と不整合、cmd_340 self-completeness 原則準拠ゆえ同梱修正) | (1) ディレクトリ kebab mv rename (2) frontmatter `name` を kebab-case に更新 (3) 本文 self-reference + 相互参照を kebab-case に統一 (4) §2 intro 「以下 4 ステップ」→「以下 5 ステップ」修正 |
