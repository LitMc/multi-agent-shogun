# Retro Forge — 実機構成コンペティション

最終更新: 2026-03-18
ステータス: Round 1 進行中

---

## コンペティション概要

MicroProse版Magic: The Gathering（Shandalar, 1997）とSimCity 2000が
Windows 98上で快適に動く実機PC構成を、足軽3名が競い合う。
5ラウンドを実施し、最も優れた構成案を競い合う形式。

**参加者（固定）:**
- 足軽1号（ashigaru1）
- 足軽2号（ashigaru2）
- 足軽3号（ashigaru3）

**評価者:** 軍師（gunshi）

---

## コンペティションルール

### 1. 提案フォーマット（必須項目）

各ラウンドで以下の形式で提案すること:

```
### コンセプト
一言でこの構成の方向性を示す（例: 「予算最小」「信頼性最優先」「当時の雰囲気重視」）

### パーツリスト
| カテゴリ | 型番・製品名 | 入手先URL | 価格（円） | 状態 | リスク評価 |
|---|---|---|---|---|---|
| CPU | ... | ... | ... | 中古 | 低 |
| マザーボード | ... | ... | ... | 中古 | 高（コンデンサ確認要） |
| メモリ | ... | ... | ... | 中古 | 低 |
| GPU | ... | ... | ... | 中古 | 低〜中 |
| サウンドカード | ... | ... | ... | 中古 | 低 |
| ストレージ | ... | ... | ... | 新品 | 低 |
| 電源ユニット | ... | ... | ... | 新品推奨 | 低 |
| （ケース） | ... | ... | ... | - | - |

**合計: ¥XXXXX**

### MTGクロック問題への対処
どのようにCPUクロック依存問題を解決するか記載

### 入手戦略
各パーツの入手ルートを説明（ヤフオク、メルカリ、eBay等）

### リスク評価
構成全体のリスクと軽減策
```

### 2. パーツリストのURL要件

- **必須**: 各パーツに実在する販売/出品ページのURLを1件以上添付
- 優先ルート: ヤフオク、Yahoo!フリマ、メルカリ、Amazon.co.jp、駿河屋
- 海外ルート可: eBay、AliExpress等（送料・関税の概算を含めること）
- **「入手可能」の定義**: 神奈川県在住の殿が1ヶ月以内に入手できること

### 3. 提案不要のもの（殿所有済み）

以下はパーツリスト・予算に**含めない**:
- CRTモニタ（ブラウン管TV + コンポーネント変換を使用予定）
- スピーカー（TVまたは所有の外付けスピーカーを使用）
- OS（Windows 98 SE）
- ゲーム本体（MicroProse MTG、SimCity 2000）

### 4. 技術的制約（必須遵守）

cmd_258調査結果（context/retro-forge.md参照）より:

1. **CPUクロック制約**: MTGはCPUサイクル依存 → Pentium 200-400MHz帯が最適（要検証）
   - 「なぜその型番を選んだか」を必ずコンセプトに含めること
   - cpukiller等のソフトウェア減速を採用する場合も明記すること
2. **コンデンサ劣化**: 1999-2003年製造マザーボードは要注意（Capacitor Plague）
   - マザーボードの状態について必ずリスク評価を記載
3. **RAM上限**: Win98はRAM 512MB超で不安定。最大256MB推奨
4. **ストレージ**: IDE HDDは経年劣化リスクあり → CF-IDE変換推奨

### 5. 評価基準と配点（軍師の評価基準）

| 評価軸 | 配点 | 評価ポイント |
|---|---|---|
| **MTG動作互換性** | 30点 | CPUクロック問題への対応策、実際に動きそうか |
| **Win98安定性・信頼性** | 25点 | マザーボード選定の適切さ、コンデンサリスク対策 |
| **コスト効率** | 20点 | 合計価格の安さ、費用対効果 |
| **入手容易性** | 15点 | URLの具体性、日本国内1ヶ月以内の実現可能性 |
| **当時の雰囲気・authenticity** | 10点 | 1998-2000年代の典型的構成への忠実度 |
| **合計** | **100点** | |

### 6. ラウンド間のルール

- **前ラウンドの提案・評価の参照義務**: 前ラウンドの全提案と軍師評価を必ず参照して改善すること
- **同一構成の再提出禁止**: 前ラウンドと全く同じ CPU + マザーボードの組み合わせは禁止
- **改善の明示**: 前ラウンドからどこをどう改善したかを冒頭に記載すること
  - Round 1はこの制約なし

### 7. 優勝判定

- **各ラウンド優勝**: 軍師採点で最高点の参加者
- **総合優勝**: 5ラウンド通算で最多優勝者。同数の場合は最終ラウンドの点数で決定
- 軍師は同点の場合のみタイブレーク理由を明示すること

---

## 評価記録

### Round 1

**ステータス:** 評価完了

#### 提案

##### 足軽1号の提案 — 「1998年の夢構成 — 当時の空気をそのまま再現」

| カテゴリ | 型番・製品名 | 入手先URL | 価格（円） | 状態 | リスク評価 |
|---|---|---|---|---|---|
| CPU | Intel Pentium II 350MHz (SL2U3/SL356) | https://www.ebay.com/itm/114985670938 | ¥3,000 | 中古 | 低 |
| マザーボード | ASUS P2B Rev.1.10 (Intel 440BX, Slot 1) | https://www.ebay.com/itm/326343503400 | ¥12,000 | 中古 | 中（コンデンサ要確認） |
| メモリ | PC100 SDRAM 128MB | https://auctions.yahoo.co.jp/search/search/pc100%20128mb/2084039543/ | ¥1,500 | 中古 | 低 |
| GPU | 3dfx Voodoo3 3000 AGP 16MB | https://www.ebay.com/itm/137104744541 | ¥8,000 | 中古 | 低〜中 |
| サウンドカード | Yamaha YMF744B-V搭載 PCI | https://page.auctions.yahoo.co.jp/jp/auction/g1059648124 | ¥2,500 | 中古 | 低 |
| ストレージ | CF-IDE変換 + CF 8GB | Amazon（変換¥1,500+CF¥2,000） | ¥3,500 | 新品 | 低 |
| 電源 | ATX 300W 新品 | https://www.amazon.co.jp/電源ユニット-300W-399W/s | ¥4,000 | 新品 | 低 |
| ケース | ATXミドルタワー | https://auctions.yahoo.co.jp/category/list/2084047245/ | ¥2,000 | 中古 | 低 |

**合計: 約¥36,500**

**MTGクロック対処:** 二段構え。①Pentium II 350MHzでハード面抑制 ②cpukiller3でCPU使用率40-60%に制限。速すぎる場合はBIOSでFSB 66MHz化（→実効233MHz相当）。

---

##### 足軽2号の提案 — 「信頼性とコスパの両立 — 安心して動く440BXマシン」

| カテゴリ | 型番・製品名 | 入手先URL | 価格（円） | 状態 | リスク評価 |
|---|---|---|---|---|---|
| CPU | Intel Pentium II 350MHz (SL2WZ) | https://auctions.yahoo.co.jp/category/list/2084044828/ | ¥1,000 | 中古 | 低 |
| マザーボード | ASUS P3B-F (Intel 440BX, Slot 1) | https://jp.mercari.com/item/m75213689821 | ¥5,000 | 中古 | 中（コンデンサ要確認） |
| メモリ | PC100 SDRAM 128MB | https://jp.mercari.com/item/m22006260010 | ¥1,000 | 中古 | 低 |
| GPU | 3dfx Voodoo3 2000 AGP 16MB | https://jp.mercari.com/item/m28851517653 | ¥10,000 | 中古・動作確認済 | 低〜中 |
| サウンドカード | Creative Sound Blaster Live! (CT4780) | https://jp.mercari.com/item/m84077256022 | ¥2,000 | 中古 | 低 |
| ストレージ（変換） | CF-IDE 3.5" 40pin変換 | https://www.amazon.co.jp/dp/B097BJX34J | ¥1,200 | 新品 | 低 |
| ストレージ（CF） | CF 8GB（東芝チップ） | https://www.amazon.co.jp/dp/B0096CGOH6 | ¥2,000 | 新品 | 低 |
| 電源 | 玄人志向 KRPW-L5-400W/80+ | https://www.amazon.co.jp/dp/B010Q2VN98 | ¥4,500 | 新品 | 低 |
| ケース | ATXミドルタワー | https://auctions.yahoo.co.jp/category/list/2084047245/ | ¥2,000 | 中古 | 低 |

**合計: ¥28,700**

**MTGクロック対処:** Pentium II 350MHzをスイートスポットとして選定。速すぎる場合はcpukiller3またはFSB 66MHz化（→実効233MHz）で対応。

---

##### 足軽3号の提案 — 「堅実安定 — 1998年の王道ゲーミングPC」

| カテゴリ | 型番・製品名 | 入手先URL | 価格（円） | 状態 | リスク評価 |
|---|---|---|---|---|---|
| CPU | Intel Pentium II 350MHz (SL2S6) | https://www.ebay.com/p/1705002654 | ¥2,000 | 中古 | 低 |
| マザーボード | ASUS P2B-B (440BX, Slot 1) | https://auctions.yahoo.co.jp/jp/auction/j1180067050 | ¥5,000 | 中古 | 中（コンデンサ要確認） |
| メモリ | PC100 SDRAM 128MB | https://auctions.yahoo.co.jp/search/search/pc100%20メモリ/2084039545/ | ¥1,000 | 中古 | 低 |
| GPU | 3dfx Voodoo3 3000 AGP 16MB | https://www.ebay.com/itm/137104744541 | ¥8,000 | 中古 | 低〜中 |
| サウンドカード | Creative Sound Blaster Live! (CT4780) | https://www.ebay.com/p/Creative-Sound-Blaster-Live-PCI-SB0410/77235320 | ¥2,000 | 中古 | 低 |
| ストレージ | CF-IDE変換(変換名人 CFIDE-401LA) + CF 8GB | https://www.amazon.co.jp/dp/B001EIG7YA | ¥3,000 | 新品 | 低 |
| 電源 | ATX 300-400W 新品 | https://www.amazon.co.jp/s?k=ATX電源+300W | ¥3,000 | 新品 | 低 |
| ケース | ATXミドルタワー | https://auctions.yahoo.co.jp/category/list/2084047245/ | ¥2,000 | 中古 | 低 |

**合計: 約¥26,000〜¥38,000**（eBay中心最安構成〜国内+高騰時）

**MTGクロック対処:** まず素の350MHzで動作確認→速すぎる場合にcpukiller3で制限→さらに必要ならFSB 66MHz化で233MHz相当。

---

#### 軍師評価

**評価日:** 2026-03-18

| 参加者 | コンセプト | MTG互換(30) | 安定性(25) | コスト(20) | 入手性(15) | 雰囲気(10) | **合計** |
|---|---|---|---|---|---|---|---|
| 🏆 足軽2号 | 信頼性とコスパの両立 | 24 | 22 | 15 | 13 | 5 | **79** |
| 足軽1号 | 1998年の夢構成 | 25 | 19 | 11 | 10 | 9 | **74** |
| 足軽3号 | 堅実安定 | 23 | 17 | 12 | 9 | 7 | **68** |

**Round 1 優勝: 足軽2号** — 入手容易性・信頼性・コストのバランスが最も優秀。

**全体講評:**
- 3名とも440BX + PII 350MHz + Voodoo3の基本骨格は適切。技術調査を正しく反映
- 共通弱点: MTGの具体的動作クロック調査が不足、コンデンサ対策が甘い、構成が酷似
- Round 2指針: MTGコミュニティ動作報告の調査必須、コスト確定値提示、差別化の強化

詳細評価: queue/reports/gunshi_report.yaml 参照

---

### Round 2

**全体改善点（Round 1 → Round 2）:**
- 全員CPU+MB変更（ルール遵守）: 3名とも Slot 1/440BX + PII 350MHz から脱却
- 全員RIVA TNT2採用: Voodoo3から転換（2D専用MTGにはGlide不要）
- 全員MTGクロック根拠追加: VOGONS/AnandTech/MicroProse公式マニュアルより
- 全員コスト確定値化: 「約」「〜」排除

#### 足軽1号 — Round 2提案

**コンセプト**: 「国内完結・Socket 370の合理的選択 — コスト半減、入手は倍速」

| カテゴリ | 製品名 | 入手先 | 価格 |
|---|---|---|---|
| CPU | Celeron 433MHz PPGA (Socket 370) | ヤフオク | ¥500 |
| MB | ASUS CUBX-L (440BX, Socket 370) | ヤフオク | ¥5,000 |
| GPU | RIVA TNT2 M64 32MB AGP | ヤフオク | ¥2,500 |
| サウンド | Yamaha YMF744B-V PCI | ヤフオク | ¥2,000 |
| メモリ | PC100 128MB DIMM | メルカリ | ¥1,000 |
| ストレージ | CF-IDE変換+8GB CF | Amazon | ¥3,200 |
| 電源 | 玄人志向 400W ATX | Amazon | ¥4,500 |
| ケース | ATXミドルタワー | ヤフオク | ¥2,000 |
| OS | Windows 98 SE DSP版 | ヤフオク | ¥1,800 |

**合計: ¥22,500**（確定値）

- **Round 1からの主な改善**: eBay依存完全排除→全パーツ国内調達、¥36,500→¥22,500（38%減）
- **差別化**: 3名中最安値・全国内調達・Socket 370選択
- **MTGクロック対処**: cpukiller3 + 200-400MHz帯が快適ゾーン（VOGONS Wiki/AnandTech根拠）
- **コンデンサ対策**: 購入前写真確認必須＋リキャップ予備費計上

#### 足軽2号 — Round 2提案

**コンセプト**: 「Celeron 300A伝説 — 1998年オーバークロック文化の象徴」

| カテゴリ | 製品名 | 入手先 | 価格 |
|---|---|---|---|
| CPU | Celeron 300A Slot 1 (SL2WM, Mendocino) | eBay | ¥5,700 |
| MB | Intel 440BX Slot 1 ATX MB | ヤフオク | ¥5,000 |
| GPU | RIVA TNT2 M64 AGP 32MB | eBay | ¥4,500 |
| サウンド | Yamaha YMF744B-V PCI | ヤフオク | ¥2,500 |
| メモリ | PC100 128MB DIMM | メルカリ | ¥1,000 |
| ストレージ | CF-IDE変換+8GB CF | Amazon | ¥3,200 |
| 電源 | 玄人志向 400W ATX | Amazon | ¥4,500 |
| ケース | ATXミドルタワー | ヤフオク | ¥2,000 |

**合計: ¥28,400**（確定値）

- **Round 1からの主な改善**: GPU Voodoo3→TNT2でコスト削減、FSBアンダークロック戦略追加、雰囲気⤴
- **差別化**: Celeron 300A（PC自作史上最有名OC CPU）、FSB変更で225〜450MHz可変制御（他2名にない機能）
- **MTGクロック対処**: 三段構え — ①300MHz定格確認 ②cpukiller3(40-70%) ③BIOS FSB 50MHz→225MHz
- **コンデンサ対策**: 購入前写真確認+リキャップ費¥2,000-3,000+代替ボード確保

#### 足軽3号 — Round 2提案

**コンセプト**: 「Socket 370革命 — Celeron 466MHz + Intel 815Eでコスパ逆転」

| カテゴリ | 製品名 | 入手先 | 価格 |
|---|---|---|---|
| CPU | Celeron 466MHz (SL3EH, Socket 370, Mendocino) | eBay | ¥5,542 |
| MB | ASUS CUSL2 (Intel 815E, Socket 370) | ヤフオク | ¥6,000 |
| GPU | RIVA TNT2 M64 32MB AGP | ヤフオク | ¥3,000 |
| サウンド | Yamaha YMF744B-V PCI | ヤフオク | ¥3,000 |
| メモリ | PC133 256MB SDRAM | メルカリ | ¥1,500 |
| ストレージ | CF-IDE変換+16GB CF | Amazon | ¥4,000 |
| 電源 | 玄人志向 400W ATX | Amazon | ¥4,500 |
| ケース | ATXミドルタワー | ヤフオク | ¥2,000 |
| OS | Windows 98 SE DSP版 | ヤフオク | ¥2,500 |

**合計: ¥32,042**（確定値）

- **Round 1からの主な改善**: P2B-B→CUSL2(Intel 815E)に完全変更、コスト確定値化、GPU独自調達
- **差別化**: Intel 815E内蔵GPU（i752）フォールバック搭載、3名中唯一の815Eプラットフォーム
- **MTGクロック対処**: Celeron 466MHzはPII 380-420MHz相当。cpukiller3で10-20%スロットル→最適速度
- **コンデンサ対策**: Nichicon採用ボード選定方針明記。815E世代のリスク評価済み

#### Round 2 暫定比較表

| 参加者 | プラットフォーム | CPU | 合計 | 主な強み |
|---|---|---|---|---|
| 足軽1号 | Socket 370 / 440BX (CUBX-L) | Celeron 433MHz | **¥22,500** | 最安値・全国内調達 |
| 足軽2号 | Slot 1 / 440BX | Celeron 300A | **¥28,400** | 伝説のOC CPU・FSB可変制御 |
| 足軽3号 | Socket 370 / Intel 815E (CUSL2) | Celeron 466MHz | **¥32,042** | 統合GPU搭載・最新プラットフォーム |

#### 軍師評価

**評価日:** 2026-03-18

| 参加者 | コンセプト | MTG互換(30) | 安定性(25) | コスト(20) | 入手性(15) | 雰囲気(10) | **合計** |
|---|---|---|---|---|---|---|---|
| 🏆 足軽1号 | 国内完結・Socket 370 | 24 | 21 | 18 | 14 | 5 | **82** |
| 足軽2号 | Celeron 300A伝説 | 28 | 16 | 13 | 10 | 9 | **76** |
| 足軽3号 | Socket 370革命・815E | 22 | 19 | 11 | 11 | 5 | **68** |

**Round 2 優勝: 足軽1号** — Round 1の弱点（eBay依存・高コスト）を完全克服。全国内調達・¥22,500最安で逆転優勝。

**全体講評:**
- Round 1指摘の改善度が勝敗を分けた。足軽1号の「eBay全排除+38%コスト削減」が圧倒的
- 足軽2号のFSB可変制御は技術的に最優秀だが、MB型番不明が致命的減点
- 足軽3号は815Eの大胆な選択も時代ズレ・コスト高が解消されず2ラウンド連続68点
- 共通弱点: GPU全員TNT2 M64で横並び再発、MTG具体的動作報告の引用なし

**通算成績:** 足軽1号 1勝(R2)・足軽2号 1勝(R1)・足軽3号 0勝

詳細評価: queue/reports/gunshi_report.yaml 参照

### Round 3

**ステータス:** 全提案受付完了 → 軍師評価待ち（gunshi_task_260_r3）

#### 足軽1号 — Round 3提案

**コンセプト**: 「1998年の自作魂 — Slot 1の黒い弾丸と伝説のBH6」

**Round 2からの改善点:**
1. **雰囲気大幅強化**: Celeron 433MHz（廉価版で雰囲気5/10最低）→ **PII 333MHz Slot 1カートリッジ**（1998年自作PCの象徴的パーツ）
2. **GPU差別化**: TNT2 M64（3名横並び）→ **Matrox Millennium G400**（MTGは2Dゲーム、2D画質最強のMatrox）
3. **MTG実機動作報告3件引用**: AnandTechで「PII 333MHzがShandalar適正速度」と直接報告されたクロック
4. **CPU+MB変更**: Celeron 433MHz+CUBX-L → **PII 333MHz+ABIT BH6**（Slot 1に回帰）

| カテゴリ | 型番・製品名 | 入手先URL | 価格（円） | 状態 |
|---|---|---|---|---|
| CPU | Intel Pentium II 333MHz (SL2S5, Deschutes, Slot 1) | https://auctions.yahoo.co.jp/closedsearch/closedsearch/2084044828/ | ¥1,500 | 中古 |
| MB | ABIT BH6 (Intel 440BX, Slot 1, ATX) | https://auctions.yahoo.co.jp/closedsearch/closedsearch/440bx/2084039547/ | ¥5,000 | 中古 |
| GPU | Matrox Millennium G400 16MB AGP | https://auctions.yahoo.co.jp/closedsearch/closedsearch/matrox%20g400/0/ | ¥3,000 | 中古 |
| サウンド | Yamaha YMF744B-V PCI | https://auctions.yahoo.co.jp/closedsearch/closedsearch/ymf744/23459/ | ¥2,000 | 中古 |
| メモリ | PC100 128MB DIMM | https://jp.mercari.com/search?keyword=PC100+128MB+SDRAM | ¥1,000 | 中古 |
| ストレージ | CF-IDE変換+CF 8GB | https://www.amazon.co.jp/dp/B001EIG7YA | ¥3,200 | 新品 |
| 電源 | ATX 300W新品 | https://www.amazon.co.jp/電源ユニット-300W-399W/s | ¥4,300 | 新品 |
| ケース | ATXミドルタワー | https://auctions.yahoo.co.jp/category/list/2084047245/ | ¥2,000 | 中古 |
| コンデンサ予備費 | 低ESR電解コンデンサ10個 | https://www.amazon.co.jp/s?k=低ESR+電解コンデンサ+105℃ | ¥2,000 | 新品 |

**合計: ¥24,000**（コンデンサ予備費込み）

**MTGクロック対処（実機動作報告3件）:**
- AnandTech: ユーザーが「**PII 333MHzでShandalarを正しい速度で動かしたい**」と組み立てた（直接的な報告）
- AnandTech: PII 400MHzでは「AI手番に最大10分」だがゲーム速度は正常 → 333MHzはさらに最適
- AnandTech + abandonwaredos: PIII以上で「Shandalarマップが速すぎて操作不能」→ PII 333MHzは安全圏

速度制御三段構え: ①PII 333MHz定格 ②cpukiller3(40-70%) ③ABIT BH6のBIOS FSB変更（66/75/83/100MHz）

#### 足軽2号 — Round 3提案

**Round 2からの改善点:**
1. **MB型番を具体化（Round 2最大敗因）**: 「440BX Slot 1 ATXマザーボード」（型番不明で安定性16/25） → **ASUS P2B-F**（具体型番、ヤフオク実出品URL付き）。ASUSは日本製コンデンサ（Nichicon/Sanyo系）採用率が高く、ABITのJackcon/Teapo問題を回避。
2. **GPU差別化（全員TNT2 M64横並び問題を解消）**: TNT2 M64 → **ATI Rage 128 GL 32MB AGP**。128bit メモリバス（TNT2 M64の64bitの2倍）。MTGは2Dカードゲームであり、ATI伝統の高画質2D描画が活きる。
3. **入手性の大幅改善**: eBay依存（CPU+GPU海外） → **全パーツ国内調達**（ヤフオク/メルカリ/Amazon.co.jp）。
4. **コスト27%削減**: ¥28,400 → **¥20,700**。足軽1号のRound 2最安値¥22,500をも下回る。
5. **MTG実機動作報告の具体的引用追加**: AnandTech「PII 333MHzでShandalarを正しい速度に」、VOGONS「VIA C3 533MHz≈PII 266MHzでShandalar用PC構築」を引用。
6. **CPU+MB変更（ルール遵守）**: Celeron 300A + 汎用440BX → **Pentium II 350MHz + ASUS P2B-F**。

**コンセプト**: 「正統派PII 350MHz — 全パーツ国内完結・具体型番・ATI差別化の堅実構成」

| カテゴリ | 型番・製品名 | 入手先URL | 価格（円） | 状態 | リスク評価 |
|---|---|---|---|---|---|
| CPU | Intel Pentium II 350MHz (SL2S6, Deschutes, Slot 1) | https://auctions.yahoo.co.jp/search/search/pentium%20ii/23336/ | ¥1,500 | 中古 | 低 |
| マザーボード | ASUS P2B-F (Intel 440BX, Slot 1, ATX) | https://auctions.yahoo.co.jp/jp/auction/n1222699351 | ¥3,500 | 中古（動作未確認） | 中（コンデンサ・動作要確認） |
| メモリ | PC100 SDRAM 128MB DIMM | https://jp.mercari.com/search?keyword=PC100+128MB | ¥1,000 | 中古 | 低 |
| GPU | ATI Rage 128 GL 32MB AGP (109-51900-01) | https://auctions.yahoo.co.jp/jp/auction/p1221019358 | ¥3,500 | 中古・動作確認済 | 低 |
| サウンドカード | Creative Sound Blaster Live! 5.1 SB0100 PCI | https://auctions.yahoo.co.jp/jp/auction/o1222582812 | ¥1,500 | 中古・動作品 | 低 |
| ストレージ（アダプタ） | CF-IDE 3.5" 変換アダプター 40ピン | https://www.amazon.co.jp/dp/B097BJX34J | ¥1,200 | 新品 | 低 |
| ストレージ（CF） | コンパクトフラッシュ 8GB | https://www.amazon.co.jp/dp/B0096CGOH6 | ¥2,000 | 新品 | 低 |
| 電源ユニット | 玄人志向 KRPW-L5-400W/80+ (ATX) | https://www.amazon.co.jp/dp/B010Q2VN98 | ¥4,500 | 新品 | 低 |
| ケース | ATXミドルタワー中古 | https://auctions.yahoo.co.jp/category/list/2084047245/ | ¥2,000 | 中古 | 低 |

**合計: ¥20,700**

**MTGクロック対処（コミュニティ実機動作報告つき）:**

*コミュニティ調査結果:*
- **AnandTech** ("Old Game runs too fast", 2004): ユーザーが「**PII 333MHzを組んでShandalarを正しい速度で動かしたい**」と発言。別ユーザーは「**PII 400MHzではAI手番に10分**」と報告（＝ゲーム速度として適正域）。PIII以上は「速すぎて操作不能」。
- **VOGONS** ("VIA EPIA 5000"): ユーザー dav3yb が「**MicroProse MTG Shandalarをプレイするため**」にVIA C3 533MHzシステムを構築。回答者が「**C3のIPCはPII/PIIIの約半分 → 533MHz C3 ≈ PII 266MHz相当**」と分析。つまりPII 266MHz相当がShandalar用として実際に選ばれた速度帯。
- **VOGONS** ("MTG Battlemage"): 「**Throttle + CPUKillerの組み合わせが最良の結果**」と複数報告。

*本構成の速度戦略:* PII 350MHzは実証済み動作域（PII 266MHz〜400MHz）の中央値。三段構え: ①PII 350MHz定格 ②cpukiller3で40-70%制限 ③ASUS P2B-FのBIOS FSB変更（66MHz→233MHz / 100MHz→350MHz）。

---

#### 足軽3号 — Round 3提案

**コンセプト**: 「ABIT BH6の逆襲 — 伝説の名板 + PII 333MHz + Matrox G400で2D最適化」

**Round 2からの改善点:**
1. **プラットフォーム時代感回復**: Intel 815E(2000年)→ **440BX(1998年)** に回帰。軍師指摘の「時代ズレ」を完全解消
2. **コスト38%削減**: ¥32,042→**¥23,500**（確定値）。3ラウンド中最大の改善幅
3. **GPU完全差別化**: TNT2 M64（3名横並び）→ **Matrox Millennium G400**。MTGは2Dゲーム → 2D最強カードが最適解
4. **MTG動作報告4件引用**: AnandTechでPII 333MHzをMTGのために組んだユーザー報告など
5. **CPU+MB変更**: CUSL2+Celeron 466MHz → **ABIT BH6+PII 333MHz**（ルール遵守）
6. **伝説的マザーボード採用**: ABIT BH6はTom's Hardware「Best 440BX Board」選出

| カテゴリ | 型番・製品名 | 入手先URL | 価格（円） | 状態 |
|---|---|---|---|---|
| CPU | Intel Pentium II 333MHz (SL2KA, Deschutes, Slot 1) | https://auctions.yahoo.co.jp/search/search/Pentium%20II%20333/2084044828/ | ¥800 | 中古 |
| MB | ABIT BH6 Rev.1.1 (Intel 440BX, Slot 1, ATX) | https://www.ebay.com/itm/336009537919 | ¥6,500 | 中古・動作確認済 |
| GPU | Matrox Millennium G400 32MB AGP (DualHead) | https://www.ebay.com/itm/146253155730 | ¥4,000 | 中古 |
| サウンド | Yamaha YMF744B-V PCI | https://auctions.yahoo.co.jp/closedsearch/closedsearch/ymf744/23459/ | ¥2,000 | 中古 |
| メモリ | PC100 SDRAM 128MB DIMM | https://jp.mercari.com/search?keyword=PC100+128MB | ¥1,000 | 中古 |
| ストレージ | CF-IDE変換+CF 8GB | https://www.amazon.co.jp/dp/B097BJX34J | ¥3,200 | 新品 |
| 電源 | ATX 300W新品 | https://www.amazon.co.jp/s?k=ATX電源+300W | ¥4,000 | 新品 |
| ケース | ATXミドルタワー | https://auctions.yahoo.co.jp/category/list/2084047245/ | ¥2,000 | 中古 |

**合計: ¥23,500**（確定値）

**MTGクロック対処（実機動作報告4件）:**
- AnandTech: 「**PII 333MHzを組んでShandalarを正しい速度で動かしたい**」（直接的ユーザー報告）
- AnandTech: PII 400MHzではゲーム速度正常（＝333MHzも適正域）
- VOGONS: VIA C3 533MHz（≈PII 266MHz相当）でShandalar用PC構築 → 266MHzでも動作可能
- MicroProse公式: 推奨Pentium 120MHz → 333MHzはその2.8倍で調整余地十分

速度制御: ①PII 333MHz定格確認 ②cpukiller3(80-90%) ③BH6 SoftMenu III FSB変更

#### Round 3 暫定比較表

| 参加者 | CPU | MB | GPU | 合計 | 主な強み |
|---|---|---|---|---|---|
| 足軽1号 | PII 333MHz | ABIT BH6 | Matrox G400 | **¥24,000** | 1998年雰囲気・MTG実証済みクロック |
| 足軽2号 | PII 350MHz | ASUS P2B-F | ATI Rage 128 GL | **¥20,700** | 最安値・全国内調達・日本製コンデンサMB |
| 足軽3号 | PII 333MHz | ABIT BH6 | Matrox G400 | **¥23,500** | コスト削減・時代感回復・MTG実証済みクロック |

⚠️ 足軽1号・3号が同一構成（BH6+PII 333MHz+G400）に収束。差別化は価格（¥500差）のみ。軍師評価で減点要因となる可能性あり。

#### 軍師評価

**評価日:** 2026-03-18

| 参加者 | コンセプト | MTG互換(30) | 安定性(25) | コスト(20) | 入手性(15) | 雰囲気(10) | **合計** |
|---|---|---|---|---|---|---|---|
| 🏆 足軽2号 | 正統派PII 350MHz・P2B-F | 27 | 23 | 18 | 14 | 6 | **88** |
| 足軽1号 | 1998年の自作魂・BH6 | 26 | 18 | 15 | 13 | 8 | **80** |
| 足軽3号 | BH6の逆襲・PII 333 | 26 | 15 | 14 | 9 | 8 | **72** |

**Round 3 優勝: 足軽2号** — R2全弱点克服（MB型番具体化・全国内・¥20,700最安）。P2B-F日本製コンデンサ論点を初提起。

**注目点:**
- 足軽1号・3号がBH6+PII 333+G400+YMF744の同一構成に収束。差別化欠如で両者減点
- 足軽2号が唯一の独自構成（P2B-F+PII 350+Rage 128 GL+SB Live!）で差別化成功
- 日本製コンデンサ(ASUS) vs 台湾系(ABIT)の品質論点が初めて浮上
- ¥20,700は全3ラウンド・全参加者の絶対最安値

**通算成績:** 足軽2号 **2勝**(R1,R3)・足軽1号 1勝(R2)・足軽3号 0勝
足軽2号がR4で優勝すれば通算3勝で総合優勝確定。

詳細評価: queue/reports/gunshi_report.yaml 参照

### Round 4

**ステータス:** 足軽3号提案完了 → 他参加者待ち

#### 足軽3号 — Round 4提案

**コンセプト**: 「秋葉原¥2万円自作 — 日本市場の雄AOpenで組むMTG最適機」

**Round 3からの改善点:**
1. **構成の完全独自化（R3最大敗因の解消）**: BH6+PII 333+G400（足軽1号と同一）→ **AOpen AX6BC+PII 266MHz+ATI Rage Pro**（全パーツ他参加者と重複なし）
2. **コスト30%削減（全ラウンド・全参加者の絶対最安値）**: ¥23,500→**¥16,500**。足軽2号R3最安¥20,700を¥4,200下回る
3. **MB品質問題の解消**: ABIT BH6（台湾系コンデンサ）→**AOpen AX6BC**（Rubycon/Nichicon混載、DOS/V POWER REPORT推奨）
4. **CPU選定の根本的見直し**: PII 333MHz→**PII 266MHz**（VOGONS実証: VIA C3 533MHz≈PII 266MHzがShandalar専用機として構築された実績）
5. **入手ルート完全国内化**: eBay依存→**全パーツ国内調達**
6. **GPU合理化**: Matrox G400(¥4,000+)→**ATI Rage Pro Turbo(¥1,000)**。MTGは2Dゲーム→3D性能不要

| カテゴリ | 型番・製品名 | 入手先URL | 価格（円） | 状態 | リスク評価 |
|---|---|---|---|---|---|
| CPU | Intel Pentium II 266MHz (SL265, Klamath, Slot 1) | https://auctions.yahoo.co.jp/category/list/2084044828/ | ¥500 | 中古 | 低 |
| マザーボード | AOpen AX6BC (Intel 440BX, Slot 1, ATX) | https://auctions.yahoo.co.jp/closedsearch/closedsearch/ax6bc/23404/ | ¥3,500 | 中古 | 中（コンデンサ確認要、Rubycon/Nichicon混載） |
| メモリ | PC100 SDRAM 128MB DIMM | https://jp.mercari.com/search?keyword=PC100+128MB+SDRAM | ¥1,000 | 中古 | 低 |
| GPU | ATI 3D Rage Pro Turbo AGP 8MB | https://auctions.yahoo.co.jp/closedsearch/closedsearch/ati%20rage/2084211538/ | ¥1,000 | 中古 | 低 |
| サウンドカード | C-Media CMI8738 PCI (4ch/6ch) | https://auctions.yahoo.co.jp/search/search/cmi8738/0/ | ¥500 | 中古 | 低 |
| ストレージ（変換） | CF-IDE 3.5" 40pin変換アダプタ | https://www.amazon.co.jp/dp/B097BJX34J | ¥1,200 | 新品 | 低 |
| ストレージ（CF） | コンパクトフラッシュ 8GB | https://www.amazon.co.jp/dp/B0096CGOH6 | ¥2,000 | 新品 | 低 |
| 電源ユニット | ATX 300W 新品 | https://www.amazon.co.jp/電源ユニット-300W-399W/s | ¥3,800 | 新品 | 低 |
| ケース | ATXミドルタワー | https://auctions.yahoo.co.jp/category/list/2084047245/ | ¥2,000 | 中古 | 低 |
| ケーブル予備 | IDE/FDDフラットケーブル新品 | https://www.amazon.co.jp/s?k=IDE+フラットケーブル | ¥1,000 | 新品 | 低 |

**合計: ¥16,500**（確定値）

**MTGクロック対処（コミュニティ実証4件）:**

*PII 266MHzがShandalar最適クロックである根拠:*
- **VOGONS** (VIA EPIA 5000): ユーザーdav3ybが「**MTG Shandalarをプレイするため**」にVIA C3 533MHzシステムを構築。回答者が「**C3のIPC≈PII/PIIIの半分 → 533MHz C3 ≈ PII 266MHz相当**」と分析。つまりPII 266MHz相当がShandalar専用機として実際に選ばれた速度帯
- **AnandTech** ("Old Game runs too fast"): 「**PII 333MHzを組んでShandalarを正しい速度で動かしたい**」→333MHzでもやや速い可能性。266MHzならさらに安全域
- **AnandTech** (同スレッド別投稿): PII 400MHzでは「AI手番に最大10分」→400MHzでも操作可能だが266MHzなら待ち時間短縮で快適
- **VOGONS Wiki**: Magic: The Gathering (1997)がCPU速度依存ゲームとして明記

*速度制御三段構え:*
①PII 266MHz定格でまず動作確認（制限なしで適正速度の可能性が最も高い）
②cpukiller3で微調整（80-95%制限、必要時のみ）
③AX6BCのBIOS FSB調整（66MHz→50/75MHz等で実効200〜300MHz帯を自在に制御）

★他参加者が「速すぎるCPUをソフトで抑える」戦略なのに対し、本構成は「ハードウェアレベルで適正速度を選ぶ」逆転の発想。

---

#### 足軽2号 — Round 4提案

**Round 3からの改善点:**
1. **雰囲気スコア大幅強化（R3最大の伸びしろ: 6/10→目標8+/10）**: 「正統派PII 350MHz」路線 → **Celeron 300A + ABIT BH6 — PC自作史上最も有名なオーバークロック・コンボ**。1998年、Tom's Hardware/AnandTech/[H]ard|OCPが一斉に報じた伝説: 「$180のCeleron 300Aを$100のBH6に挿し、BIOSのFSBを66→100MHzに変えるだけで$500のPentium II 450と互角」。電圧変更不要、特殊冷却不要。PC自作文化の原点となったコンボ。
2. **CPU+MB完全変更（ルール遵守）**: PII 350MHz + ASUS P2B-F → **Celeron 300A (Mendocino) + ABIT BH6**。
3. **GPU差別化継続**: ATI Rage 128 GL → **Matrox Millennium G200 8MB AGP**。Matroxは「2D画質のMatrox」として当時絶対的定評。MTGは2Dカードゲーム＝2D最強ブランドが最適解。
4. **コスト維持**: ¥20,700 → **¥20,700**（同額維持、雰囲気を大幅改善しつつコスト増ゼロ）。
5. **MTG速度制御をSoftMenu IIIで史上最強に**: P2B-FのFSBジャンパ → **BH6のSoftMenu III**（BIOS上で66/75/83/100MHz FSB切替）。Celeron 300A × FSB変更で225/300/337.5/375/450MHzの5段階ハードウェア速度制御。全ラウンド全参加者で最も柔軟なMTG速度調整。
6. **BH6コンデンサリスク対策**: ABIT系台湾コンデンサ（Jackcon/Teapo）の弱点を認識の上、リキャップ予備費¥2,000を計上。購入前に出品者写真でコンデンサ膨張を確認、膨張ゼロの個体のみ入札。

**コンセプト**: 「Celeron 300Aの伝説 — PC自作史上最も有名なオーバークロック物語を再現する」

1998年末、Intel Celeron 300A（Mendocino）とABIT BH6（440BX）の組み合わせは、PC自作文化を永遠に変えた。Tom's Hardwareは BH6を「Best 440BX Board」に選出。AnandTechのCeleron 300Aオーバークロック記事は同サイト最多読記事の一つ。TechSpotは「The Most Memorable Overclocking-Friendly CPUs」でCeleron 300Aを歴代トップに選出。
「300Aを買ってBH6に挿せ」——この一言が、世界中のPCエンスージアストの合言葉だった。

本構成はその伝説を再現しつつ、MTGの速度要件に最適化する。Celeron 300Aの300MHz定格はShandalar動作域（PII 266-400MHz相当）のド真ん中。SoftMenu IIIのFSB制御で225-450MHzの5段階ハードウェア調整が可能。Matrox G200で2D画質を最大化し、Sound Blaster Live!で当時のサウンド体験を再現する。

| カテゴリ | 型番・製品名 | 入手先URL | 価格（円） | 状態 | リスク評価 |
|---|---|---|---|---|---|
| CPU | Intel Celeron 300A Slot 1 (SL2WM, Mendocino, 300MHz/66MHz FSB) | https://auctions.yahoo.co.jp/search/search/celeron%20300a/23336/ | ¥2,000 | 中古 | 低 |
| マザーボード | ABIT BH6 (Intel 440BX, Slot 1, ATX, SoftMenu III) | https://auctions.yahoo.co.jp/closedsearch/closedsearch/abit%20bh6/23336/ | ¥3,500 | 中古 | 中（台湾製コンデンサ要確認） |
| メモリ | PC100 SDRAM 128MB DIMM | https://jp.mercari.com/search?keyword=PC100+128MB | ¥1,000 | 中古 | 低 |
| GPU | Matrox Millennium G200 8MB AGP (MGA-G200) | https://auctions.yahoo.co.jp/closedsearch/closedsearch/matrox%20g200/2084211538/ | ¥2,000 | 中古 | 低 |
| サウンドカード | Creative Sound Blaster Live! Value CT4780 PCI | https://page.auctions.yahoo.co.jp/jp/auction/w1061110768 | ¥1,500 | 中古 | 低 |
| ストレージ（アダプタ） | CF-IDE 3.5" 変換アダプター 40ピン | https://www.amazon.co.jp/dp/B097BJX34J | ¥1,200 | 新品 | 低 |
| ストレージ（CF） | コンパクトフラッシュ 8GB | https://www.amazon.co.jp/dp/B0096CGOH6 | ¥2,000 | 新品 | 低 |
| 電源ユニット | ATX 300W新品 | https://www.amazon.co.jp/s?k=ATX電源+300W | ¥3,500 | 新品 | 低 |
| ケース | ATXミドルタワー中古 | https://auctions.yahoo.co.jp/category/list/2084047245/ | ¥2,000 | 中古 | 低 |
| リキャップ予備費 | 低ESR電解コンデンサ10個セット（105℃品） | https://www.amazon.co.jp/s?k=低ESR+電解コンデンサ+105℃ | ¥2,000 | 新品 | — |

**合計: ¥20,700**

**MTGクロック対処（SoftMenu IIIによる5段階ハードウェア速度制御）:**

*コミュニティ動作報告（R3引用の継続+補強）:*
- **AnandTech** ("Old Game runs too fast"): ユーザーが「**PII 333MHzを組んでShandalarを正しい速度で動かしたい**」と発言。別ユーザーは「**PII 400MHzではAI手番に10分**」＝ゲーム速度として適正域。
- **VOGONS** (VIA EPIA 5000): VIA C3 533MHz（**≈PII 266MHz相当**）でShandalar用PC構築。→266-400MHzがShandalar動作域。
- **VOGONS** (MTG Battlemage): 「**Throttle + CPUKillerの組み合わせが最良**」と複数報告。
- **Tom's Hardware**: Celeron 300Aを「14 Of The Most Legendary Overclocking-Friendly CPUs」に選出。BH6を「Best 440BX Board」に選出。

*Celeron 300AのMTG適合性:*
Celeron 300A（Mendocino）は128KB on-die L2キャッシュ搭載。PIIの512KB半速キャッシュと比較して、MTGのような小規模プログラムではクロックあたり同等以上の性能。**Celeron 300MHz ≈ PII 300MHz相当** = 動作域（266-400MHz）の中央値。

*SoftMenu III 5段階ハードウェア速度制御（全構成中最強の柔軟性）:*

| FSB設定 | 実効クロック | MTG用途 |
|---------|-------------|---------|
| 50MHz | 225MHz | 動作域下限以下（最も安全、最遅） |
| 66MHz | 300MHz | **定格・動作域中央（推奨開始点）** |
| 75MHz | 337.5MHz | 動作域中央〜上位 |
| 83MHz | 375MHz | 動作域上位 |
| 100MHz | 450MHz | **伝説のOC速度**（SimCity 2000最適・MTGはcpukiller併用） |

＋cpukiller3で各段階をさらにソフトウェア微調整。**ケースを開けずにBIOSだけで5段階、ソフトで無段階** = 全ラウンド全参加者で最も自在な速度制御。

**入手戦略:**
- **全パーツ国内調達（R3から継続）**: ヤフオク/メルカリ/Amazon.co.jpのみ。eBayゼロ。
- **CPU (Celeron 300A)**: ヤフオク落札相場¥1,000-4,000、平均¥2,830。¥2,000で十分入手可能。Slot 1版を選定（BH6はSlot 1）。
- **MB (ABIT BH6)**: ヤフオク落札相場¥520-9,630、平均¥3,302。¥3,500で入手可能。購入前にコンデンサ膨張の写真確認必須。
- **GPU (Matrox G200)**: ヤフオク落札相場¥550-5,000、平均¥2,555。¥2,000で入手可能。
- **サウンド (SB Live! CT4780)**: ヤフオク¥451-1,480。OEM品（Dell/HP/NEC）が大量流通。
- **ストレージ・電源**: Amazon.co.jp新品即日配送。
- **リキャップ予備費**: Amazon.co.jpで低ESR 105℃品10個セット。BH6到着後に膨張コンデンサがあれば交換。

**リスク評価:**

| リスク | 深刻度 | 軽減策 |
|---|---|---|
| BH6コンデンサ劣化（台湾製Jackcon/Teapo） | 中 | リキャップ予備費¥2,000計上。購入前写真確認で膨張ゼロ個体を選定。BH6はOC人気で良品が市場に多い |
| BH6動作不安定 | 低〜中 | SoftMenu IIIで電圧・FSBを保守的に設定可能。定格66MHz FSBなら安定性リスク極低 |
| Celeron 300Aの個体差 | 低 | 定格300MHz使用なら個体差は無関係。OC耐性は副次的メリット |
| Matrox G200のWin98ドライバ | 低 | Matrox公式Win98ドライバあり。VOGONS/PhilsComputerLabで実績多数 |
| MTGが300MHzで速すぎる | 極低 | 動作域中央。速すぎてもSoftMenu IIIで225MHzまで落とせる |

---

#### 足軽1号 — Round 4提案

**コンセプト**: 「VOGONS実証済み — PII 266MHzはMTG Shandalarのために選ばれた速度」

**Round 3からの改善点:**
1. **コンデンサ問題への根本回答**: ABIT BH6（台湾系Jackcon/Teapo）→ **AOpen AX6BC（Sanyo日本製コンデンサ）**。HardwareZoneレビューで「populated with high quality Sanyo Electrolytic capacitors」と明記
2. **足軽3号との同一構成問題を解消**: BH6+PII 333+G400 → **AX6BC+PII 266+ATI Rage Pro**（3パーツ全変更）
3. **MTG最適速度の根拠を格上げ**: PII 333MHz（AnandTech希望的報告）→ **PII 266MHz（VOGONS直接実行ビルド**）
4. **コスト削減**: ¥24,000 → **¥17,700**（26%減）

| カテゴリ | 型番・製品名 | 入手先URL | 価格（円） | 状態 |
|---|---|---|---|---|
| CPU | Intel Pentium II 266MHz (Klamath SL2HC, Slot 1) | https://auctions.yahoo.co.jp/category/list/2084044828/ | ¥500 | 中古 |
| MB | AOpen AX6BC (Intel 440BX, Slot 1, Sanyo製コンデンサ) | https://auctions.yahoo.co.jp/closedsearch/closedsearch/ax6bc/0/ | ¥3,500 | 中古 |
| GPU | ATI 3D Rage Pro Turbo AGP 8MB | https://auctions.yahoo.co.jp/search/search/ati%20rage/2084039481/ | ¥1,500 | 中古 |
| サウンド | Yamaha YMF744B-V PCI | https://auctions.yahoo.co.jp/closedsearch/closedsearch/ymf744/23459/ | ¥2,000 | 中古 |
| メモリ | PC100 128MB DIMM | https://jp.mercari.com/search?keyword=PC100+128MB+SDRAM | ¥1,000 | 中古 |
| ストレージ | CF-IDE変換+CF 8GB | https://www.amazon.co.jp/dp/B097BJX34J | ¥3,200 | 新品 |
| 電源 | ATX 300W新品 | https://www.amazon.co.jp/s?k=ATX電源+300W | ¥4,000 | 新品 |
| ケース | ATXミドルタワー | https://auctions.yahoo.co.jp/category/list/2084047245/ | ¥2,000 | 中古 |

**合計: ¥17,700**（確定値）

**MTGクロック対処（VOGONS実行済みビルド根拠）:**
- **VOGONS** (VIA EPIA 5000): ユーザーdav3ybが「**MTG Shandalarをプレイするため**」にVIA C3 533MHzシステムを構築 → 「C3 533MHz ≈ **PII 266MHz相当**」。希望ではなく実際に実行されたビルド
- **AnandTech**: PII 333MHzが適正速度として選定・PII 400MHzで操作可能 → 266MHzは最も安全な動作域下限
- AX6BCのBIOS FSB変更で66→75→83→100MHz（266→300→332→400MHz）と上方調整可能

PII 266MHz定格で適正速度 → ソフトウェアスロットリング不要。「速すぎたら下げる」より「ちょうどよい速度から始める」が安全。

#### Round 4 暫定比較表

| 参加者 | CPU | MB | GPU | 合計 | 主な強み |
|---|---|---|---|---|---|
| 足軽2号 | Celeron 300A | ABIT BH6 | Matrox G200 | **¥20,700** | PC自作史上最も有名OC伝説・SoftMenu III 5段階制御 |
| 足軽1号 | PII 266MHz | AOpen AX6BC | ATI Rage Pro | **¥17,700** | VOGONS実証済みMTG最適速度・Sanyo日本製コンデンサ |
| 足軽3号 | PII 266MHz | AOpen AX6BC | ATI Rage Pro | **¥16,500** | 全ラウンド絶対最安値・「適正速度を選ぶ」逆転の発想 |

⚠️ 足軽1号・3号がCPU+MB+GPUで同一構成に2ラウンド連続収束。差異はサウンド（YMF744 vs CMI8738）と価格（¥1,200差）のみ。

**軍師評価待ち（gunshi_task_260_r4）**

### Round 5
（後続ラウンドで追記）

---

## 最終結果
（全ラウンド完了後に記録）
