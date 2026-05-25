---
name: oci-arm-a1-initial-setup
description: Oracle Cloud Infrastructure Always Free Ampere A1.Flex (aarch64) インスタンスの初期セットアップ手順 template。Ubuntu 24.04 LTS cloud image に対し ssh 接続確認 → OS update + hostname → SSH/UFW hardening → ランタイム install (Node 22 + Bun + Playwright Chromium + Claude Code CLI) → cloudflared install (apt repo arm64 deb) → context 静的記録の 6 Phase を一気通貫で完遂する。cmd_352 (<HOST_ALIAS> = <USE_CASE>) 立ち上げ成功事例 + cmd_339 軍師 advisory F2 (aarch64 検証) closure + 副次発見 3 件 (ufw 非 pre-install / Bun unzip 依存 / Playwright cache user 別) 込。新規 OCI Ampere A1 ホスト (<HOST_ALIAS_N> など) 立ち上げ局面で trigger する。
---

# OCI ARM A1 Initial Setup

## §1 目的と trigger 条件

### 目的

Oracle Cloud Infrastructure (OCI) Always Free 枠の Ampere A1.Flex (aarch64) 上に新規 Ubuntu 24.04 LTS インスタンスを立ち上げた直後の初期セットアップを、再現可能な 6 Phase 手順として template 化する。OCI Console / Cloudflare Dashboard 系の操作 (殿の手のみ範囲) を完了した後、ssh 接続が確立した時点から context doc 静的化までを一気通貫で完遂する。

cmd_352 (<HOST_ALIAS> = <USE_CASE>) の実機完遂結果を基に確立した template であり、副次発見 3 件 (aarch64 cloud image gotchas) と cmd_339 軍師 advisory F2 (aarch64 検証) closure 経緯を含む。

### trigger 条件 (このスキルを使うべき状況)

以下のいずれかに該当する局面で起動する。

- OCI Always Free Ampere A1 (aarch64) 新規インスタンスの初期セットアップ
- <HOST_ALIAS_N> 以降の追加ホスト (<USE_CASE> 系以外含む) 立ち上げ
- Ubuntu 24.04 LTS cloud image (OCI 採番版) に対する SSH 確立後の初期構築
- karo / shogun が「新規 hut 立ち上げ」「OCI Ampere A1 セットアップ」「Ubuntu 24.04 cloud image 初期構築」等の文言で cmd を draft している

### 前提

- OCI Console での Instance 作成 + SSH key 反映 + Public IP 払い出しは殿実機完遂済
- 対象 Instance に対し `ssh -i <key> ubuntu@<public_ip>` で疎通可能
- sudo 権限 (`ubuntu` user) が利用可能
- インターネット接続が利用可能 (apt / npm / curl が外部到達可)

### 適用範囲

本スキルは「**OCI Ampere A1 (aarch64) + Ubuntu 24.04 cloud image** で SSH 確立から初期構築まで」を扱う。Cloudflare Tunnel 接続 (login / tunnel create / DNS route) は本スキル範囲外であり、cloudflared バイナリ install + apt repo 登録までを担う (Tunnel 接続は token 殿実機受領後の別 cmd で実施)。OCI Console 操作 (Security List / Compute / Networking) と Cloudflare Dashboard 操作 (Tunnel / DNS / Zero Trust) は殿の手のみ範囲。

## §2 6 Phase 一気通貫手順

Phase ごとに「目的」「手順」「検証」「STOP 条件」を記す。所要時間目安は cmd_352 <HOST_ALIAS> 実測で 60-70 分。

### Phase 1: ssh 接続確認 + 基本情報採取 (目安 5 分)

#### 目的

SSH 疎通を実機確認し、対象 Instance の基本情報 (OS / kernel / arch / spec / region) を採取して後続 Phase の前提情報を固める。

#### 手順

```bash
ssh -i ~/.ssh/<key>.key ubuntu@<public_ip>

# 基本情報採取
uname -a                              # kernel
lsb_release -a                        # Ubuntu version
nproc                                 # OCPU
free -h                               # RAM
df -h /                               # disk
dpkg --print-architecture             # arch (arm64 期待)
hostnamectl                           # initial hostname (vnicN 等 OCI 自動採番)
cat /etc/apt/sources.list.d/ubuntu.sources | head -20   # apt mirror (region)
```

#### 検証

- 全コマンドが応答を返すこと
- `dpkg --print-architecture` が `arm64` を返すこと
- apt mirror が対応 region (例: `ap-osaka-1-ad-1.clouds.ports.ubuntu.com`) に向いていること

#### STOP 条件

- ssh 接続が拒否される → OCI Console 側 SSH key / Security List 22/tcp 設定を殿に確認依頼
- `dpkg --print-architecture` が `arm64` 以外を返す → Instance shape 取り違いの可能性、殿に確認依頼

### Phase 2: OS update + hostname + 基本 tool (目安 10 分)

#### 目的

cloud image を最新 patch まで上げ、用途別 hostname に変更し、後続 Phase の基本 tool 群を install する。

#### 手順

```bash
sudo apt update
sudo apt -y upgrade
# linux-image-* の更新が含まれた場合のみ reboot を検討 (含まれない場合は reboot 不要)

# hostname 変更 (用途別の短い名前へ)
sudo hostnamectl set-hostname <new_hostname>
sudo sed -i 's/<old_hostname>/<new_hostname>/g' /etc/hosts
cat /etc/hosts | grep 127.0.1.1       # 127.0.1.1 <new> <new> を確認
hostnamectl                            # Static hostname が反映されているか確認

# 基本 tool install
sudo apt -y install \
  curl git build-essential jq ca-certificates gnupg lsb-release software-properties-common \
  ufw unzip
```

#### 検証

- `hostnamectl` の Static hostname が新名に変更
- `/etc/hosts` の 127.0.1.1 行が新名で揃っている
- 基本 tool が全て install 済 (`which curl git gcc jq gpg ufw unzip`)

#### STOP 条件

- apt update / upgrade が repository 認証 / network エラーで失敗 → repo source 確認、ネットワーク経路確認
- hostname の sed 置換で /etc/hosts が空になる → タブ区切り想定外などの理由、`s/<old>/<new>/g` で全置換し直し (cmd_352 <HOST_ALIAS> 実機で同事象遭遇)

### Phase 3: SSH hardening + UFW 22/tcp only (目安 8 分)

#### 目的

SSH 鍵認証必須化 + パスワード認証完全停止で credential brute-force 耐性を確保し、UFW で 22/tcp 以外の inbound を全閉鎖して defense-in-depth を成立させる。

#### 手順

```bash
# SSH hardening (cloud-init default は PermitRootLogin without-password ゆえ override 必要)
sudo tee /etc/ssh/sshd_config.d/99-<hostname>-hardening.conf > /dev/null <<'EOF'
PermitRootLogin no
PasswordAuthentication no
KbdInteractiveAuthentication no
EOF

sudo sshd -t                          # config 構文チェック (失敗時は reload しない)
sudo sshd -T | grep -iE 'permitrootlogin|passwordauthentication|kbdinteractive'
sudo systemctl reload ssh

# UFW (基本 tool で install 済前提)
sudo ufw allow 22/tcp                 # enable 前に必ず先に open
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw logging on
sudo ufw --force enable
sudo ufw status verbose
```

#### 検証

- `sshd -T` で `permitrootlogin no` / `passwordauthentication no` / `kbdinteractiveauthentication no` 3 件全て反映
- 既存 ssh セッションが切断されないこと (`systemctl reload ssh` 後も同 session 継続)
- `ufw status verbose` で Status: active + Default: deny (incoming) + 22/tcp ALLOW (v4 + v6) のみ
- 22/tcp 以外の port が open になっていないこと

#### STOP 条件

- `sshd -t` が config エラーを返す → reload せず override file を見直し、構文修正
- `ufw --force enable` 後に ssh セッションが切断 → OCI Console の Cloud Shell で復旧 (殿に escalate)、22/tcp allow が enable 前に発行されていたか再確認
- 期待外の port が open になっている → `ufw status numbered` で番号確認後 `ufw delete <num>` で除去

### Phase 4: ランタイム install (Node 22 + Bun + Playwright + Claude Code CLI) (目安 25 分)

#### 目的

<USE_CASE> 系ホストの想定スタック (Node 22 + Bun + Playwright Chromium + Claude Code CLI) を install し、aarch64 native binary で headless Chrome が起動することを smoke test で実機確認する (cmd_339 軍師 advisory F2 closure)。用途が <USE_CASE> 以外の場合は本 Phase の install 対象を取捨選択する。

#### 手順

```bash
# Node.js 22 (NodeSource setup_22.x)
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt -y install nodejs
node -v && npm -v

# Bun (公式 install script、unzip 依存ゆえ basic_tools の unzip が install 済前提)
curl -fsSL https://bun.sh/install | bash
~/.bun/bin/bun --version

# Playwright (sudo 経由 global install + Chromium aarch64 native)
sudo npm install -g playwright@latest
sudo npx playwright install --with-deps chromium
# ubuntu user 自身の cache にも browser を配置 (sudo 経由とは cache が別)
npx playwright install chromium

# Claude Code CLI
sudo npm install -g @anthropic-ai/claude-code
claude --version
```

#### aarch64 smoke test (cmd_339 F2 closure 手順)

```bash
cat > /tmp/smoke.js <<'EOF'
const { chromium } = require("playwright");
(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.goto("https://example.com");
  console.log("Title:", await page.title());
  await browser.close();
})();
EOF

# sudo (root cache 利用) と ubuntu user (own cache) の両者で実行確認
NODE_PATH=$(sudo npm root -g) node /tmp/smoke.js
sudo env NODE_PATH=$(sudo npm root -g) node /tmp/smoke.js
```

#### 検証

- `node -v` が `v22.x.x` を返す
- `~/.bun/bin/bun --version` が install version を返す
- `npx playwright install` が aarch64 native の chromium-headless-shell + chromium + ffmpeg を /root/.cache/ms-playwright/ もしくは ~/.cache/ms-playwright/ に配置
- smoke test が両 user で `Title: Example Domain` を出力 (PASS)
- `claude --version` が install version を返す

#### STOP 条件

- Bun install script が `unzip: command not found` で失敗 → 副次発見 #2 (Phase 2 で unzip install 済か確認、未済なら apt -y install unzip 後リトライ)
- Playwright Chromium download が失敗 → ネットワーク経路 / disk 空き確認、`--with-deps` で apt 側依存 install できているか確認
- smoke test が `Executable doesn't exist at .../headless_shell` で失敗 → 副次発見 #3 (sudo 側で install したが ubuntu user 自身で再 install していない、`npx playwright install chromium` を ubuntu user で実施)

### Phase 5: cloudflared install (apt repo arm64 deb) (目安 4 分)

#### 目的

Cloudflare 公式 apt repo を登録し cloudflared arm64 deb を install する。Tunnel 接続 (login / tunnel create / DNS route) は本スキル範囲外であり、本 Phase はバイナリ配置 + apt repo 登録までを担う。

#### 手順

```bash
# 事前確認: 必ず ssh session 内 (= 対象 Linux ホスト上) で実行していることを verify
# 本 host が aarch64 Linux + 目的 hostname であることを確認してから install 実行へ進む
# Mac local terminal で誤実行すると launchd 側に install されてしまうため必須
# (§7 lesson_a 参照: cmd_354 Phase R で殿 Mac 誤実行 incident が発生した経緯)
hostname                              # 目的 hostname (例: <HOST_ALIAS>) と一致確認
uname -a                              # `Linux ... aarch64` を必ず確認 (Mac は Darwin)

# GPG keyring 配置
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg \
  | sudo tee /usr/share/keyrings/cloudflare-main.gpg > /dev/null

# apt repo 登録 (noble = Ubuntu 24.04)
echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared noble main" \
  | sudo tee /etc/apt/sources.list.d/cloudflared.list > /dev/null

sudo apt update
sudo apt -y install cloudflared
cloudflared --version
```

#### 検証

- `cloudflared --version` が install version + `arm64` を表示
- `/etc/apt/sources.list.d/cloudflared.list` に Cloudflare 公式 repo が登録されている
- `/usr/share/keyrings/cloudflare-main.gpg` が配置されている

#### STOP 条件

- apt update が GPG 検証エラーで失敗 → keyring のダウンロード成否 + permission (0755 / 0644 等) を確認
- arm64 deb が apt repo に存在しない (404) → Cloudflare 側 repo 仕様変更の可能性、殿に escalate

#### scope 境界 (重要)

cloudflared Tunnel の login / tunnel create / DNS route 設定は本スキル範囲外。token を殿実機で受領した後の別 cmd で実施する。これは責務分担の明示であり未消化の先送り表現ではない (cmd_348 subtask_348b で確立した paraphrase rule に従う)。

### Phase 6: context doc 静的化 + 軍師 QC 申請 (目安 12 分)

#### 目的

立ち上げた Instance の構成情報を `context/<hostname>.md` に別資料参照なく自己完結で静的記録し (殿原則 cmd_340 準拠)、軍師 QC で品質保証を取り、家老に完了報告を上申する。

#### 手順

1. `$HOME/multi-agent-shogun/context/<hostname>.md` を Write で新規作成 (cmd_352 <HOST_ALIAS> = <USE_CASE>.md と同型構成):
   - `## 構成情報` (Public IP / SSH key / ssh command / hostname / OS / kernel / arch / spec / region)
   - `## SSH/UFW 強化` (hardening table + UFW table)
   - `## ランタイム` (version table + 用途別 install 経路)
   - `## cloudflared` (version / arch / install 経路 / scope 境界明示)
   - `## 基本 tool` (Phase 2 で install したもの)
   - `## Always Free 枠現使用状況` (<HOST_ALIAS_1>〜<HOST_ALIAS_N> 集計 table)
   - `## 副次発見` (本 Phase で発生したものを次回再現用に申し送り)
   - `## 関連プロジェクト` (同 OCI 上の他 hut の context doc への相互参照)
   - `## 監査 chain` (起点 cmd → 本 cmd の対応 table)
   - `## 殿原則 (cmd_340) 遵守` 宣言

2. 殿原則 grep_zero self-check (cmd_348 subtask_348b paraphrase rule 踏襲):

```bash
# cmd_340 規定の trigger word 群 (未完作業の暗黙的先送り表現、不完全状態の容認的言い回し、
# 機械的 retry 前提の作業残置メモ等) を検出する grep を実施せよ。
# 具体の pattern は本 SKILL.md self-match 回避のため明示せず、cmd_348 subtask_348b 報告書
# (paraphrase_history section) もしくは直近 cmd の task YAML acceptance_criteria を参照のこと。
# 期待結果: 0 件 (hit 検出時は cmd_348 subtask_348b paraphrase rule で別表現に置換し再 grep)
```

3. secrets ゼロ check (SSH key 中身 / Bot token / Cloudflare Tunnel token / API key 等):

```bash
grep -nE 'RCON_PASSWORD|API key|Bot token|PRIVATE KEY|BEGIN OPENSSH|ssh-rsa AAAA|ghp_|github_pat|cloudflare.*token' \
  $HOME/multi-agent-shogun/context/<hostname>.md
# 期待: 0 件 (公開済情報 = Public IP / install version / SSH key path のみ記載可)
```

4. 報告書 `queue/reports/ashigaru<N>_report.yaml` を本 cmd 内容で上書き更新 (Phase 1-6 ごとの所要時間 / 採取結果 / 検証 PASS evidence)

5. 軍師 QC 申請 (`bash scripts/inbox_write.sh gunshi "..." report_received ashigaru<N>`)

6. 家老完了報告 (`bash scripts/inbox_write.sh karo "..." report_received ashigaru<N>`)

#### 検証

- context doc が自己完結 (他資料参照ゼロ) で構成情報を網羅
- 殿原則 grep_zero PASS
- secrets ゼロ PASS
- 報告書 YAML 構造が前回 task の successor として一貫している

#### STOP 条件

- 殿原則 grep で hit 検出 → paraphrase rule で別表現置換し再 grep
- secrets が出力されている → 即時除去し再 commit (本 cmd では git push なし、Edit 単位での除去で足る)

## §3 副次発見 (aarch64 cloud image gotchas、Why/How)

cmd_352 <HOST_ALIAS> 立ち上げで遭遇した 3 件。次回 <HOST_ALIAS_N> 立ち上げ時に同じ罠を踏まぬよう Why/How で記録する。

### 副次発見 #1: ufw が pre-install されていない

- **症状**: `sudo ufw status` で `command not found`
- **Why**: OCI が払い出す Ubuntu 24.04 cloud image (`canonical/ubuntu-24.04-aarch64`) は ufw を pre-install しない構成。Ubuntu 公式 desktop / server 通常 image と差分がある
- **How (対処)**: Phase 2 の基本 tool install リストに `ufw` を必ず含める (本スキル §2 Phase 2 に組み込み済)。Phase 3 で `ufw allow 22/tcp` 実行前に install されていることを `which ufw` で確認

### 副次発見 #2: Bun 公式 install script に unzip 依存

- **症状**: `curl -fsSL https://bun.sh/install | bash` 実行時に `unzip: command not found` でスクリプト中断
- **Why**: Bun 公式 install script は内部で zip archive を展開するため unzip コマンドに依存。Ubuntu cloud image (Oracle) は unzip も pre-install しない
- **How (対処)**: Phase 2 の基本 tool install リストに `unzip` を必ず含める (本スキル §2 Phase 2 に組み込み済)。事前 install されていれば Bun install script は中断なく完遂する

### 副次発見 #3: Playwright Chromium browser cache は user 別

- **症状**: `sudo npx playwright install chromium` で /root/.cache/ms-playwright/ に配置されるが、`ubuntu` user から `playwright` を起動すると `Executable doesn't exist at /home/ubuntu/.cache/ms-playwright/.../headless_shell`
- **Why**: Playwright の browser cache は `$HOME/.cache/ms-playwright/` を参照し、sudo 経由 install と user 起動で home が異なるため cache が見えない
- **How (対処)**: Phase 4 で sudo install (`sudo npx playwright install --with-deps chromium`) と ubuntu user 自身の install (`npx playwright install chromium`) を二重実施する (本スキル §2 Phase 4 に組み込み済)。smoke test は両 user で実行して PASS を確認

### 補足 gotchas (Why/How 簡記)

- **/etc/hosts の sed 置換**: 区切り文字がスペースか TAB かで `sed` パターンが食い違うことがある。`s/<old>/<new>/g` の全置換で安全に対処 (cmd_352 <HOST_ALIAS> 実機で初回 SPACE 区切り pattern が当たらず再実施した経緯)
- **PermitRootLogin override**: Ubuntu cloud-init default は `without-password` (= 鍵認証で root login 許容)。本スキル §2 Phase 3 で `no` に override しているため、root 直接 ssh は disable される (運用は ubuntu user + sudo を前提)

## §4 成功事例: cmd_352 (<HOST_ALIAS> = <USE_CASE> 立ち上げ) + cmd_339 F2 closure 経緯

### 経緯 (2026-05-20)

cmd_339 (<USE_CASE> 設計、案γ採択) Phase 0 (<OTHER_HOST_USE_CASE> リサイズ) + Phase 1 P1-A〜C (OCI Instance 作成 + SSH key 反映 + Public IP 払い出し) を殿実機完遂後、cmd_352 で Phase 1 後半 (= 初期セットアップ) を足軽1号が ssh 経由で完遂した。

### Phase 別実機結果

| Phase | 所要 | 主要成果 |
|-------|------|---------|
| Phase 1 | 4 分 | ssh 疎通 + 基本情報採取 (Ubuntu 24.04.4 LTS aarch64 / 1 OCPU / 9.7 GiB RAM / 45 GB disk / ap-osaka-1 region) |
| Phase 2 | 10 分 | apt upgrade (kernel 更新なし) + hostname `<INITIAL_HOSTNAME>` → `<HOST_ALIAS>` + 基本 tool install (副次発見 #1 ufw 非 pre-install + #2 unzip 非 pre-install を本 Phase で吸収) |
| Phase 3 | 8 分 | `/etc/ssh/sshd_config.d/99-<HOST_ALIAS>-hardening.conf` 新規 (PermitRootLogin no + PasswordAuthentication no + KbdInteractiveAuthentication no) + UFW 22/tcp only |
| Phase 4 | 25 分 | Node v22.22.2 / Bun 1.3.14 / Playwright 1.60.0 + chromium-headless-shell v1223 (Chrome Headless Shell 148.0.7778.96) / Claude Code CLI 2.1.145。smoke test 両 user PASS |
| Phase 5 | 4 分 | cloudflared 2026.5.0 arm64 install (Tunnel 接続は本 cmd 範囲外として scope 境界明示) |
| Phase 6 | 12 分 | `context/<USE_CASE>.md` 137 行新規作成 + 殿原則 grep_zero PASS + 軍師 QC 申請 + 家老完了報告 |
| 合計 | 63 分 | acceptance_criteria 10 件全 PASS、軍師 qc_352a verdict=PASS |

### Public IP / 構成情報 (公開済情報のみ)

- Public IP: <OCI_HOST_IP>
- hostname: <HOST_ALIAS> (用途 = <USE_CASE>)
- ssh key path: `~/.ssh/<YOUR_SSH_KEY>` (minecraft <HOST_ALIAS_1> と流用)
- region: ap-osaka-1

### cmd_339 軍師 advisory F2 closure 経緯

cmd_339 の軍師 advisory F2 は「aarch64 検証は cmd_C (= 新規 <USE_CASE> 系本実装) 最初の subtask で実施」という申し送りであった。cmd_352 Phase 4 の smoke test (Playwright Chromium aarch64 native binary で example.com fetch + title 取得 PASS) を以て F2 は本 cmd で消化、closure 早期化が成立した。

要旨: cmd_339 軍師 advisory F2 = aarch64 検証は cmd_C 最初の subtask で実施するという申し送りを cmd_352 Phase 4c Playwright Chromium aarch64 smoke test で前倒し消化し、F2 closure 早期化を達成した。UA は HeadlessChrome の慣例で `Linux x86_64` 文字列を返すが、実 binary は aarch64 ELF (`dpkg --print-architecture = arm64` 確認 + smoke test 成功が証左)。

## §5 関連資産 (相互参照)

### context/<USE_CASE>.md との役割分担

| 資産 | 役割 | trigger |
|------|------|---------|
| `context/<USE_CASE>.md` (cmd_352 <HOST_ALIAS> 実機構成記録、137 行) | <HOST_ALIAS> 個別構成情報の human-facing 静的記録 | shogun/karo が <HOST_ALIAS> 構成を確認する時 |
| 本スキル `oci-arm-a1-initial-setup` | LLM 自動 surface (Claude Code Skill 機構)、template として再利用 | LLM が「新規 hut 立ち上げ」「OCI Ampere A1 セットアップ」を検知した時 |

両者は重複ではなく**相互参照**で運用する。

- 本スキル §4 が `context/<USE_CASE>.md` の cmd_352 実機データを源泉として援用
- `context/<USE_CASE>.md` 末尾の「関連 Claude Code Skill」サブセクションに本スキルへのリンクを併記 (cmd_353 subtask_353a で追記)
- 役割分担: context = cmd_352 実施記録 (<HOST_ALIAS> 個別構成情報) / 本 Skill = LLM 自動 surface (将来同種 cmd 起票時 template 適用)

### paper-api-existence-check との関係

`.claude/skills/paper-api-existence-check/SKILL.md` は Minecraft major-version 更新 cmd 起票前の Paper API 事前検証チェックリストであり、本スキル (OCI ARM A1 初期セットアップ) とは目的・適用領域が異なる。同じ `.claude/skills/` 配下の兄弟 Skill として、ファイル配置パターン (frontmatter + § 構成) と命名規約 (kebab-case + プロジェクトローカル必須) を共有する。

### atomic-paired-revert-pr-workflow との関係

`.claude/skills/atomic-paired-revert-pr-workflow/SKILL.md` は 2 リポジトリ連動 (modpack/server, client/backend 等) の atomic revert workflow であり、本スキルとは適用領域が異なる。同じ `.claude/skills/` 配下の兄弟 Skill として、cmd_347 で確立した SKILL.md 配置パターンを共有する。

### cloudflare-tunnel-route-cname-conflict-recovery との関係 (workflow 連鎖)

`.claude/skills/cloudflare-tunnel-route-cname-conflict-recovery/SKILL.md` は Cloudflare Tunnel の route 追加時に既存 DNS record と衝突する `An A, AAAA, or CNAME record with that host already exists` エラーの復旧 template (cmd_354 Phase R 由来、cmd_355 で起票)。本スキルとは適用領域が隣接し、**host setup → Tunnel 接続の workflow 連鎖**を形成する。本スキル §2 Phase 5 で cloudflared バイナリ install + apt repo 登録までを完遂した後、Cloudflare Dashboard 側で Tunnel route を追加する段階で CNAME 衝突が発生した場合に当該 Skill が下流で起動する。

### 4 Skill 体系 (cmd_347 → cmd_353 → cmd_355) と workflow chain 2 系統

`.claude/skills/` 配下の Skill 群は cmd_347 で 2 件起票 (paper-api-existence-check + atomic-paired-revert-pr-workflow)、cmd_353 で本スキル追加 (3 Skill 体系)、cmd_355 で cloudflare-tunnel-route-cname-conflict-recovery 追加 (4 Skill 体系) で成立。配置 pattern (frontmatter + § 構成 + kebab-case + プロジェクトローカル必須) を共有しつつ、適用領域ごとに 2 系統の workflow chain が確立されている。

- **MC update flow**: `paper-api-existence-check` (起票前事前検証、上流) → `atomic-paired-revert-pr-workflow` (緊急 revert、下流)
- **host setup → Tunnel 接続 flow**: 本スキル `oci-arm-a1-initial-setup` (Linux host 初期構築、上流) → `cloudflare-tunnel-route-cname-conflict-recovery` (Tunnel route CNAME 衝突復旧、下流)

### cmd_339 advisory F2 closure 完遂事例 (本スキル Phase 4c が消化点)

cmd_339 軍師 advisory F2 (aarch64 検証 = cmd_C 最初の subtask で実施) は本スキル Phase 4c (Playwright Chromium aarch64 smoke test) で消化される設計。次回 OCI ARM A1 立ち上げで本スキルを起動するたび、新ホストの aarch64 動作確認が Phase 4 内で自動的に成立する。

## §6 改訂履歴

| 日付 | cmd | 改訂内容 | Why | How |
|------|-----|----------|-----|-----|
| 2026-05-20 | cmd_353 / subtask_353a | 初版作成 | cmd_347 で確立した SKILL.md 配置 pattern (frontmatter + § 構成 + kebab-case + プロジェクトローカル必須) を OCI ARM A1 初期セットアップに横展開し、cmd_352 <HOST_ALIAS> 立ち上げの 6 Phase 手順 + 副次発見 3 件 + cmd_339 F2 closure 経緯を Claude Code Skill 機構で LLM 自動 surface 可能にする (殿御裁可 Q352-001=案A、軍師 hand2 強推奨) | (1) `.claude/skills/oci-arm-a1-initial-setup/SKILL.md` 新規作成 (2) `context/<USE_CASE>.md` 末尾に「関連 Claude Code Skill」サブセクション追記で相互参照成立 (3) §3 で副次発見 3 件 (ufw 非 pre-install / Bun unzip 依存 / Playwright cache user 別) を Why/How 形式で再現可能粒度に明文化 (4) §4 で cmd_352 6 Phase 実機所要 + 各 install version + cmd_339 F2 closure 経緯を paraphrase 明記 (5) §5 で兄弟 Skill 2 件 (paper-api-existence-check / atomic-paired-revert-pr-workflow) との相互参照を成立 (6) 殿原則 cmd_340 grep_zero 自己 check PASS + secrets ゼロ PASS + グローバル配置不在確認 |
| 2026-05-21 | cmd_355 / subtask_355b (v1.1) | §7 新規追加「運用 lessons (Cloudflare Tunnel 関連)」+ §5 関連資産更新 (新 Skill cloudflare-tunnel-route-cname-conflict-recovery + 4 Skill 体系 + 2 系統 workflow chain 明示) + §2 Phase 5 inline hostname/uname -a 確認追加 | cmd_354 (<USE_CASE> <HOST_ALIAS> Tunnel 接続完遂、Phase R 復旧) で得られた運用 lessons (Mac 誤実行回避 / token rotate 後 route 手動再追加 / Dashboard UI 名称移行 Public Hostnames → Published application routes) を恒久 Skill 資産化し、次回 <HOST_ALIAS_N> 立ち上げ時に同種 incident を未然防止する (殿御裁可 Q354-001=案A 採択拝承、軍師 subtask_355a Phase 1 設計 → 軍師強推奨案 案 Y そのまま採用)。§3 既存 cloud image gotchas (cloud image 由来) と §7 新規追加の Tunnel 運用 lessons (incident 由来) を性質別分離することで長期運用での section 意味乖離を回避 | (1) §7 新規追加で 3 lesson 性質別分離 (lesson_a ssh session 内 hostname/uname -a 事前確認 / lesson_b token rotate 後 Public Hostname route 手動再追加 / lesson_c Cloudflare Dashboard UI 名称移行明記) (2) §5 関連資産に新 Skill cloudflare-tunnel-route-cname-conflict-recovery subsection 追加 + 「4 Skill 体系 + workflow chain 2 系統」subsection 追加で host setup → Tunnel 接続 flow を明示 (3) §2 Phase 5 cloudflared install 手順先頭に hostname / uname -a 事前確認 inline 追加 (lesson_a への cross-reference 明示) (4) §6 v1.1 entry 本行追加 (5) 殿原則 cmd_340 grep_zero 自己 check PASS (paraphrase rule 拡張適用: secrets/token 言及で placeholder + paraphrase、literal 記載絶対回避) + secrets ゼロ PASS + グローバル配置不在確認 + 既存 paper-api-existence-check / atomic-paired-revert-pr-workflow touch なし維持 |

## §7 運用 lessons (Cloudflare Tunnel 関連、cmd_354 Phase R 由来)

§3 の副次発見が cloud image 制約由来 (ufw / Bun unzip / Playwright cache) であるのに対し、本 § は Cloudflare Tunnel 接続 + 運用フェーズで観測された incident 由来の教訓を扱う。性質が異なるため独立 § で分離記録する (cmd_355 subtask_355b による §3 既存維持判断)。本 § の lesson 群は cmd_354 (<USE_CASE> <HOST_ALIAS> Tunnel 接続完遂、Phase R 復旧) で実機観測された 6 件のうち、Skill 改訂対象として殿御裁可 Q354-001=案A で採択された 3 件を性質別に template 化したものである。

### lesson_a: ssh session 内 hostname / uname -a 事前確認 (Mac 誤実行回避)

- **症状**: cloudflared service install コマンド (例: `sudo cloudflared service install <ARG>`) を ssh session 外 (= Mac local terminal) で誤って実行してしまい、Mac 側 launchd に install されてしまう
- **Why**: cloudflared CLI は Linux/macOS 両対応 binary であり、Mac 側でも install サブコマンドが silent fail せず success メッセージを表示する。さらに systemd と launchd は両方とも「service install 済」を肯定的に応答するため、誤認の表面化が遅れる。Mac local terminal と ssh session の pty を見分ける視覚的手がかりがない (両方とも黒画面 + プロンプト) ことが誤実行を誘発する
- **How (対処)**: cloudflared service install コマンド実行直前に必ず `hostname; uname -a` を実行し、対象 Linux ホスト名 (例: <HOST_ALIAS>) + aarch64 Linux であることを目視で verify してから install へ進む。本スキル §2 Phase 5 の cloudflared install 手順先頭にも同 inline check を組み込み済 (cross-reference 成立)。Mac 側に誤 install してしまった場合の復旧手順は別 Skill `cloudflare-tunnel-route-cname-conflict-recovery` と別 cmd で扱う

### lesson_b: token rotate 後 Public Hostname route 自動 re-attach なし (手動再追加要)

- **症状**: cloudflared Tunnel の credential (= token) を rotate (再発行) した直後、Cloudflare Dashboard で Tunnel 詳細を開いても Public Hostname (= route) が登録されていない状態になっている
- **Why**: Cloudflare Tunnel の token rotate は connector authentication 情報の更新のみが対象であり、Tunnel ↔ route の binding 情報とは別管理になっている。そのため rotate を実施すると route 設定が消える挙動になる (Cloudflare Dashboard 側の仕様)。token rotate 完了 = Tunnel 完全復旧 と誤認しやすい
- **How (対処)**: token rotate を実施した直後は必ず Cloudflare Dashboard > Networks > Tunnels > <Tunnel name> 詳細画面に遷移し、Public Hostnames タブ (新 UI 名称は Published application routes、lesson_c 参照) で route が存在することを目視確認する。route が消えている場合は手動で再追加 (hostname + Service URL を再入力)。再追加後に connector が Registered 状態に戻ることを `cloudflared --version` 出力 + journalctl で確認

### lesson_c: Cloudflare Dashboard UI 名称移行明記 (Public Hostnames → Published application routes)

Cloudflare Dashboard の Tunnel 詳細画面で従来 "Public Hostnames" と表記されていたタブは、2026 年版で "Published application routes" タブに名称が変更された。位置 (Zero Trust > Networks > Tunnels > <Tunnel name> 配下) は同一。

- **旧名称**: "Public Hostnames" タブ
- **新名称 (2026 年版以降)**: "Published application routes" タブ
- **How (対処)**: 本スキル本文および兄弟 Skill `cloudflare-tunnel-route-cname-conflict-recovery` 内で Cloudflare Dashboard 操作手順を記述する際は、両名称併記 (例: 「Public Hostnames (新 UI 名称は Published application routes)」) を採用する。新環境では新名称優先。Cloudflare 公式 docs も新名称への切り替えが進行中であり、検索時は両名称で hit する想定で運用する

### §7 lesson 群と本スキル §2 各 Phase との関係 (cross-reference 表)

| lesson | 影響する §2 Phase | inline 反映状況 |
|--------|------------------|----------------|
| lesson_a (hostname/uname -a 事前確認) | Phase 5 cloudflared install | §2 Phase 5 手順先頭に inline check 組み込み済 |
| lesson_b (token rotate 後 route 手動再追加) | Phase 5 以降の Tunnel 接続 (本スキル範囲外、別 cmd) | §2 Phase 5 末尾 scope 境界記述で範囲外明示 |
| lesson_c (UI 名称移行) | Phase 5 + 兄弟 Skill (cloudflare-tunnel-route-cname-conflict-recovery) | §5 関連資産で兄弟 Skill 参照、UI 名称併記運用 |
