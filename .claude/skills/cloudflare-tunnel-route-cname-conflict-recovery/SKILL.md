---
name: cloudflare-tunnel-route-cname-conflict-recovery
description: Cloudflare Tunnel で Public Hostname (2026 年版 UI は Published application routes) を追加する際、対象 hostname の既存 DNS A/AAAA/CNAME record と衝突して `An A, AAAA, or CNAME record with that host already exists` エラーが発生した時の復旧手順 template。Cloudflare Dashboard > DNS > Records タブで既存 record を手動削除 → Tunnel route 再追加 → dig + curl で疎通検証の 4 Step で機械的に復旧する。cmd_354 Phase R (<USE_CASE> <HOST_ALIAS> 接続中の CNAME 衝突事案、kix04/05/03/05 4 connections Registered で復旧) で確立した組織知。token rotate / Tunnel rebuild / hostname 再利用 / 既存 zone への新 Tunnel 接続などで trigger する。
---

# Cloudflare Tunnel Route CNAME Conflict Recovery

## §1 目的と trigger 条件

### 目的

Cloudflare Tunnel に Public Hostname (= Tunnel route) を追加する際、同 hostname の DNS record (A / AAAA / CNAME) が既存 zone に既に存在している場合、Cloudflare Dashboard 側から `An A, AAAA, or CNAME record with that host already exists` エラーが返り route 追加が block される。この衝突を解消し、Tunnel route + connector Registered 状態まで復旧する手順を template 化する。

cmd_354 Phase R (2026-05-21、<USE_CASE> <HOST_ALIAS> = <TUNNEL_HOSTNAME>) で実機確立した手順を、再利用可能な機械的再現可能粒度で記録する。

### trigger 条件 (このスキルを使うべき状況)

以下のいずれかに該当する局面で起動する。

- Cloudflare Tunnel 詳細画面で Public Hostname を新規追加した直後、`An A, AAAA, or CNAME record with that host already exists` エラー文言が表示された
- token rotate を実施した直後、Tunnel route が消えており再追加しようとした際に上記エラー文言が発生
- 既存 hostname (= 過去に別 Tunnel または直接 origin proxy として使用していたもの) を新 Tunnel に再 binding しようとして上記エラー文言が発生
- 既存 Cloudflare zone (= 別目的の DNS record が共存している zone) に新 Tunnel を接続しようとして上記エラー文言が発生

### 前提

- Cloudflare Dashboard の DNS Records タブ + Zero Trust > Networks > Tunnels タブ両方の編集権限を保持
- 対象 hostname の Tunnel route 追加意図が既存 DNS record より優先することが確定済 (= 既存 record 削除しても他システムへの影響がないと判断済)
- cloudflared connector 側 (= ssh 先 Linux ホスト) で `cloudflared --version` + `systemctl status cloudflared` が応答可能

### 適用範囲

本スキルは「**Cloudflare Tunnel route 追加時に既存 DNS record と衝突した場合の復旧**」に限定する。Tunnel の新規作成 (Tunnel UUID 発行 + connector token 発行) や cloudflared バイナリ install は本スキル範囲外であり、前者は Cloudflare Dashboard 側操作 (殿の手のみ範囲)、後者は兄弟 Skill `oci-arm-a1-initial-setup` §2 Phase 5 が担う。Cloudflare Dashboard 操作および credential 系の発行・rotate は殿の手のみ範囲とし、ssh 経由で実施できる検証手順 (dig / curl) のみ本スキル内で扱う。

## §2 症状の特定 (エラー文言 + UI 位置)

### エラー文言 (literal)

Cloudflare Dashboard で Public Hostname (= route) を追加 (Save) した瞬間、以下文言の error toast / inline message が表示される。

```
An A, AAAA, or CNAME record with that host already exists.
```

文言は Cloudflare Dashboard 英語 UI 表示準拠。日本語 UI でも同等内容が表示されるが文言は localization 版になる。本スキルでは英語版文言を grep / 検索キーとして採用する。

### 発生する UI 位置

- パンくず階層: Zero Trust > Networks > Tunnels > <Tunnel name> > **Public Hostnames** タブ
- 2026 年版 UI 名称: 上記 "Public Hostnames" は **"Published application routes"** タブに名称が変更されている (位置は同一)
- 操作: 「Add a public hostname」ボタン押下 → Subdomain / Domain / Type / URL 入力 → Save 押下時点でエラー発生
- 兄弟 Skill `oci-arm-a1-initial-setup` v1.1 §7 lesson_c でも同 UI 名称移行を明文化済

### 衝突原因 (DNS Records タブ側の既存 record)

- パンくず階層: <account> > <domain> > DNS > Records
- 対象 hostname の type=A / AAAA / CNAME の record が pre-existing (= 過去の Tunnel 設定 / 直接 origin 設定 / 別目的の record などに由来)
- Cloudflare の制約上、同一 hostname に対し DNS record と Tunnel route binding は排他関係 (片方のみ存在可能) のため衝突

## §3 復旧手順 (4 Step 機械的再現可能)

各 Step に「目的」「操作」「検証」を併記する。所要時間目安は cmd_354 Phase R 実測で 10-15 分。

### Step 1: 衝突している既存 DNS record の特定 + 削除

#### 目的

衝突源である既存 DNS record (A / AAAA / CNAME) を Cloudflare Dashboard 側で削除し、Tunnel route 再追加の前提を整える。

#### 操作 (Cloudflare Dashboard、殿の手)

1. Cloudflare Dashboard にログイン
2. 対象 account > 対象 domain (zone) を選択
3. 左 nav > DNS > Records タブを開く
4. Type / Name filter で対象 hostname を絞り込み (例: name=review)
5. 該当 record の右端「...」メニュー > Delete を選択
6. 削除確認ダイアログで Delete 確定

#### 検証 (ssh 経由 = 足軽実施可能)

```bash
# 削除直後の DNS 反映確認
dig <対象 hostname>
# 期待: NXDOMAIN または旧 record が消えていることを確認
# 注意: Cloudflare DNS の TTL に従い反映に最大数分かかることがある
```

#### STOP 条件

- 削除権限がない (= editor role / DNS edit 権限なし) → 殿に escalate
- 該当 hostname の record が複数 (A + AAAA 等) ある → 全 record の削除要否を殿と判断、A/AAAA 両方衝突する場合は両方削除

### Step 2: Tunnel route 再追加 (Public Hostnames / Published application routes タブ)

#### 目的

Cloudflare Tunnel 詳細画面で対象 hostname を Tunnel route として再追加し、衝突を解消した状態で binding を成立させる。

#### 操作 (Cloudflare Dashboard、殿の手)

1. 左 nav > Zero Trust > Networks > Tunnels > 対象 Tunnel 名を選択
2. Public Hostnames タブ (新 UI 名称は **Published application routes**) を選択
3. 「Add a public hostname」ボタン押下
4. Subdomain (例: review) / Domain (例: <YOUR_CF_ZONE>) / Path (任意) を入力
5. Service Type (例: HTTP) / URL (例: localhost:80) を入力
6. Save 押下 → エラー文言が出ないことを確認 (= 衝突解消)

#### 検証 (Cloudflare Dashboard、殿の手 + ssh 経由検証)

- Dashboard 側: 追加した route が一覧に表示されていること
- Dashboard 側: connector 状態が `Registered` 表示で接続維持されていること (cmd_354 Phase R 実測値: kix04 / kix05 / kix03 / kix05 の 4 connections Registered)

```bash
# ssh 先 Linux ホストで connector 健全性確認
systemctl status cloudflared           # active (running) を確認
journalctl -u cloudflared -n 20        # `Registered tunnel connection` を含む直近 log を確認
```

#### STOP 条件

- 再度同じ衝突エラーが発生 → Step 1 の record 削除が DNS に未反映の可能性、`dig <hostname>` で NXDOMAIN を確認してから再試行
- connector が Registered 状態にならない → 別問題の可能性 (token rotate 直後の credential ファイル不整合等)、殿に escalate

### Step 3: DNS 反映確認 (dig で Cloudflare proxy IP 解決)

#### 目的

Tunnel route 追加に伴い Cloudflare が自動生成した proxy 経由 CNAME (例: `<UUID>.cfargotunnel.com`) + Cloudflare proxy IP が公開 DNS で resolve されることを確認する。

#### 操作 (ssh 経由 = 足軽実施可能)

```bash
# Cloudflare proxy IP 解決確認
dig <対象 hostname> +short
# 期待: Cloudflare の proxy IP 群 (104.x / 172.x / 188.x 等の Cloudflare CIDR 内 IP) が返る

# 詳細確認 (CNAME chain 含む)
dig <対象 hostname>
# 期待: ANSWER section に Cloudflare proxy IP が記載され、AUTHORITY/STATUS=NOERROR
```

#### 検証

- 返却 IP が Cloudflare の公開 IP range (https://www.cloudflare.com/ips/ 参照) に該当
- TTL が短め (= Cloudflare 標準) であること

#### STOP 条件

- NXDOMAIN が継続して返る (5 分以上経過) → Tunnel route 追加が Cloudflare 側で commit されていない可能性、Dashboard で route 存在再確認 → 必要なら Step 2 再実施

### Step 4: HTTPS 疎通確認 (curl で CF Access login redirect 期待)

#### 目的

Cloudflare proxy + Tunnel + connector の経路を end-to-end で疎通確認する。Tunnel route 単体では Cloudflare Access (= ログイン認証層) と組み合わせて使用するケースが多く、その場合は curl で 302 redirect (Access login challenge) の応答を期待する。

#### 操作 (ssh 経由 = 足軽実施可能)

```bash
curl -sI https://<対象 hostname> | head -20
# 期待 (Cloudflare Access protected の場合):
#   HTTP/2 302
#   location: https://<account>.cloudflareaccess.com/cdn-cgi/access/login/...
#   server: cloudflare
#   cf-ray: <ray-id>
#
# 期待 (Cloudflare Access なし、純 Tunnel の場合):
#   HTTP/2 200 or 30x (origin service 応答に依存)
#   server: cloudflare
#   cf-ray: <ray-id>
```

#### 検証

- `server: cloudflare` ヘッダが返る (= Cloudflare proxy を通過している証拠)
- `cf-ray: <ray-id>` が応答に含まれる
- Cloudflare Access 設定済の場合は 302 redirect で login challenge URL を指していること

#### STOP 条件

- `server` ヘッダが cloudflare 以外 → DNS が Cloudflare proxy ではなく直接 origin に向いている可能性、Step 3 の dig 結果と CF proxy IP range を再確認
- HTTP 502 / 521 / 522 が継続 → connector → origin service の経路問題、Tunnel ingress 設定 (cloudflared config.yml or Dashboard ingress) と origin service の起動状態を確認

## §4 成功事例: cmd_354 Phase R (<USE_CASE> <HOST_ALIAS> 接続中の CNAME 衝突復旧)

### 経緯 (2026-05-21)

cmd_354 (<USE_CASE> <HOST_ALIAS> = <TUNNEL_HOSTNAME> の Cloudflare Tunnel 接続) の Phase R (復旧 phase) で本 Skill 対象 incident が発生。Tunnel credential rotate (案 X 採択) 直後に新 token で connector を再起動した後、Public Hostname を追加しようとして本 Skill 文言 (`An A, AAAA, or CNAME record with that host already exists`) エラーに遭遇。

### Phase R 実施手順 (実測)

1. **Step 1 実施**: Cloudflare Dashboard > DNS > Records タブで `review` hostname の既存 CNAME record (= 別目的の旧設定由来) を発見、Delete で削除
2. **Step 2 実施**: Zero Trust > Networks > Tunnels > <TUNNEL_NAME> > Public Hostnames タブで `<TUNNEL_HOSTNAME>` を Service URL `http://localhost:80` で再追加 → 衝突エラーなく Save 成功
3. **Step 3 実施**: <HOST_ALIAS> ssh から `dig <TUNNEL_HOSTNAME>` で Cloudflare proxy IP 確認
4. **Step 4 実施**: <HOST_ALIAS> ssh から `curl -sI https://<TUNNEL_HOSTNAME>` で 302 redirect (Cloudflare Access login) 確認

### 復旧結果 (実測)

- Tunnel name: <TUNNEL_NAME> / Tunnel UUID 先頭: <TUNNEL_UUID_PREFIX>...
- Connections: **kix04 / kix05 / kix03 / kix05 の 4 connections 全 Registered**
- Connector host: <HOST_ALIAS> (<OCI_HOST_IP>) / systemd active / Memory 15 MB
- Access Application: <USE_CASE> (Self-hosted and private) / Allow lord only (email rule)
- 殿スマホ動作確認: Browser ✅ / Cloudflare Access login challenge ✅ / 復旧後 review ホスト動作確認完遂

### 確立された組織知

1. **本スキル**: 4 Step 復旧手順を機械的 surface 化
2. **`context/<USE_CASE>.md`** 末尾 Cloudflare Tunnel 構成 section (cmd_354 由来、Phase R 教訓 6 件記載): 本スキル成功事例の paraphrase 出典
3. **兄弟 Skill `oci-arm-a1-initial-setup` v1.1 §7 lesson_b**: token rotate 後 Public Hostname route 自動 re-attach なし (= 本スキルが起動する代表的な trigger 状況) を上流 lesson として記載

## §5 関連資産 (相互参照、4 Skill 体系の workflow 連鎖)

### 兄弟 Skill 3 件との関係

| 兄弟 Skill | 役割 | 本スキルとの関係 |
|------------|------|----------------|
| `.claude/skills/oci-arm-a1-initial-setup/SKILL.md` (cmd_353 由来、v1.1 cmd_355 改訂) | OCI Ampere A1 (aarch64) + Ubuntu 24.04 初期 6 Phase + cloudflared バイナリ install (Phase 5) + 運用 lessons (§7 新規) | **直接上流**: Phase 5 で cloudflared install + apt repo 登録完遂 → 本スキルが Tunnel route 追加段階で起動。§7 lesson_b (token rotate 後 route 手動再追加) は本スキル trigger 条件の代表例 |
| `.claude/skills/paper-api-existence-check/SKILL.md` (cmd_347 由来) | Minecraft major-version 更新 cmd 起票前 Paper API 事前検証 | **兄弟配置** (kebab-case + プロジェクトローカル + frontmatter + § 構成 pattern 共有)、適用領域は独立 (MC update flow) |
| `.claude/skills/atomic-paired-revert-pr-workflow/SKILL.md` (cmd_347 由来) | 2 リポ連動 atomic revert workflow | **兄弟配置** (同上)、適用領域は独立 (MC update flow の下流) |

### context/<USE_CASE>.md との役割分担

| 資産 | 役割 | trigger |
|------|------|---------|
| `context/<USE_CASE>.md` 末尾 Cloudflare Tunnel 構成 section (cmd_354 由来、Phase R 教訓 6 件) | <HOST_ALIAS> 個別構成情報 + Phase R 実機経緯の human-facing 静的記録 | shogun/karo が <HOST_ALIAS> 構成 + cmd_354 Phase R 経緯を確認する時 |
| 本スキル `cloudflare-tunnel-route-cname-conflict-recovery` | LLM 自動 surface (Claude Code Skill 機構)、template として再利用 | LLM が `An A, AAAA, or CNAME record with that host already exists` エラー文言 / Cloudflare Tunnel route 衝突 / Public Hostname 追加失敗 を検知した時 |

両者は重複ではなく**相互参照**で運用する。本スキル §4 が `context/<USE_CASE>.md` の cmd_354 Phase R 実機データを源泉として援用、`context/<USE_CASE>.md` 末尾 section が 4 Skill 体系一覧で本スキルを明示。

### 4 Skill 体系 (cmd_347 → cmd_353 → cmd_355) と workflow chain 2 系統

`.claude/skills/` 配下の Skill 群は cmd_347 で 2 件起票 (paper-api-existence-check + atomic-paired-revert-pr-workflow)、cmd_353 で oci-arm-a1-initial-setup 追加 (3 Skill 体系)、cmd_355 で本スキル追加 (4 Skill 体系) で成立。配置 pattern (frontmatter + § 構成 + kebab-case + プロジェクトローカル必須) を共有しつつ、適用領域ごとに 2 系統の workflow chain が確立されている。

- **MC update flow**: `paper-api-existence-check` (起票前事前検証、上流) → `atomic-paired-revert-pr-workflow` (緊急 revert、下流)
- **host setup → Tunnel 接続 flow**: `oci-arm-a1-initial-setup` (Linux host 初期構築 + cloudflared install、上流) → 本スキル (Tunnel route CNAME 衝突復旧、下流)

新規 OCI ARM A1 ホスト立ち上げから Cloudflare Tunnel 接続完遂までを 2 Skill 連鎖で template 化することにより、LLM 自動 surface 時の trigger 連鎖性が向上し、cmd 起票時に上流 / 下流双方の Skill が一括で参照可能となる。

## §6 改訂履歴

| 日付 | cmd | 改訂内容 | Why | How |
|------|-----|----------|-----|-----|
| 2026-05-21 | cmd_355 / subtask_355b | 初版作成 (v1.0) | cmd_354 Phase R で実機確立した CNAME 衝突復旧手順を恒久 Skill 資産化し、次回同種 incident (token rotate 直後 / Tunnel rebuild / hostname 再利用 / 既存 zone への新 Tunnel 接続) で機械的に復旧可能にする。同時に Q354-004 採択の Cloudflare Dashboard UI 名称移行 (Public Hostnames → Published application routes) を §2 / §3 で同梱明文化する (殿御裁可 Q354-001=案A 採択拝承、軍師 subtask_355a Phase 1 設計 → 軍師強推奨案そのまま採用) | (1) `.claude/skills/cloudflare-tunnel-route-cname-conflict-recovery/SKILL.md` 新規作成 (kebab-case + プロジェクトローカル必須、cmd_348 確立配置ルール遵守) (2) §1-§6 標準構成 (cmd_347/353 同型 pattern) (3) §3 で復旧手順を 4 Step (record 削除 / route 再追加 / dig 反映確認 / curl 疎通確認) で機械的再現可能粒度に明文化 (4) §4 で cmd_354 Phase R 実機経緯を paraphrase 表現で記載 (kix04/05/03/05 4 connections Registered 等の構成情報のみ literal、credential / token 本体は記載しない) (5) §5 で 4 Skill 体系 + workflow chain 2 系統を明示し、兄弟 Skill `oci-arm-a1-initial-setup` v1.1 §7 lesson_b と上流-下流関係を成立 (6) 殿原則 cmd_340 grep_zero 自己 check PASS (paraphrase rule 拡張適用: secrets/token 言及で placeholder + paraphrase、literal 記載絶対回避) + secrets ゼロ PASS + グローバル ~/.claude/skills/ 配置不在確認 + 既存 paper-api-existence-check / atomic-paired-revert-pr-workflow touch なし維持 |
