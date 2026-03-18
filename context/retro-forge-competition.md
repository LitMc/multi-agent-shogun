# Retro Forge — 実機構成コンペティション

最終更新: 2026-03-18
ステータス: 全5ラウンド完了・合議完了 — 総合優勝: 足軽2号 / 3部門推薦構成確定

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

#### 軍師評価

**評価日:** 2026-03-18

| 参加者 | コンセプト | MTG互換(30) | 安定性(25) | コスト(20) | 入手性(15) | 雰囲気(10) | **合計** |
|---|---|---|---|---|---|---|---|
| 🏆 足軽2号 | Celeron 300A伝説・BH6 | 29 | 18 | 13 | 13 | **10** | **83** |
| 足軽1号 | VOGONS実証PII 266・AX6BC | 25 | 22 | 15 | 12 | 3 | **77** |
| 足軽3号 | 秋葉原¥2万自作・AX6BC | 25 | 19 | 19 | 12 | 2 | **77** |

**Round 4 優勝: 足軽2号** — 300A+BH6伝説コンボで雰囲気10/10満点（全コンペ唯一）。SoftMenu III 5段階FSB制御はMTG速度調整でも最強。

**🏆 総合優勝確定: 足軽2号（通算3勝: R1, R3, R4）** — 残り1ラウンドの結果に関わらず最多勝確定。

**注目点:**
- 足軽1号・3号が2ラウンド連続同一構成（R3: BH6+PII333+G400、R4: AX6BC+PII266+RagePro）。厳格減点適用
- 足軽2号は4ラウンドで毎回異なる戦略（信頼性→ロマン→堅実→伝説）。創造性と適応力が圧倒的
- 足軽3号 ¥16,500は全ラウンド・全参加者の絶対最安値を更新
- PII 266MHz vs Celeron 300A: 技術的にはFSB可変の300Aが優位

**通算成績:** ★足軽2号 **3勝**(R1,R3,R4)=総合優勝・足軽1号 1勝(R2)・足軽3号 0勝

詳細評価: queue/reports/gunshi_report.yaml 参照

### Round 5

**ステータス:** 全3名提案完了 → 軍師評価待ち

#### 足軽1号 — Round 5提案（最終ラウンド）

**Round 4からの改善点:**
1. **雰囲気の根本的変革（R4最大敗因: 3/10→目標8+/10）**: ATI Rage Pro+YMF744（OEM寄せ集め）→ **ASUS P2B + NVIDIA Riva TNT + SB Live!**。全パーツが1998年のPC雑誌（Tom's Hardware/AnandTech）で推奨・レビューされた「PC自作文化の定番」
2. **2ラウンド連続同一構成の完全脱却（CPU・MB・GPU全3パーツ変更）**: AOpen AX6BC + PII 266MHz + ATI Rage Pro → **ASUS P2B + PII 300MHz + NVIDIA Riva TNT**（全ラウンド・全参加者で唯一のRiva TNT採用）
3. **コンデンサ信頼性向上**: AOpen AX6BC（Sanyo） → **ASUS P2B（Nichicon/Rubycon）**。Capacitor Plague（1999-2003）の被害対象外
4. **MTG速度帯最適化**: PII 266MHz（VOGONS実証下限） → **PII 300MHz**（VOGONS 266MHz実証とAnandTech 333MHz実証の中間値。定格でcpukiller不要域）

**コンセプト**: 「The 1998 Reviewer's Reference — PC雑誌が選んだベンチマーク構成の再現」

1998年、世界中のPCハードウェアレビューサイトがリファレンスとして選んだのがASUS P2Bだった。Tom's Hardwareは1998年春のSlot 1マザーレビューでP2Bを推奨し、AnandTechはP2Bを全CPUベンチマークのリファレンスボードとして採用した。NVIDIA Riva TNTはRaspberry Pi財団が「NVIDIAを世界に知らしめた最初のGPU」と評する歴史的チップ。Sound Blaster Live!（EMU10K1）はEAXを世界初搭載した革命的サウンドカード。パーツの1つ1つが、PC自作文化の歴史に名を残す定番中の定番。

| カテゴリ | 型番・製品名 | 入手先URL | 価格（円） | 状態 | リスク評価 |
|---|---|---|---|---|---|
| CPU | Intel Pentium II 300MHz (Deschutes SL2W8, Slot 1, 66MHz FSB) | https://auctions.yahoo.co.jp/category/list/2084044828/ | ¥800 | 中古 | 低 |
| マザーボード | ASUS P2B Rev.1.02+ (Intel 440BX, Slot 1, ATX, Nichicon/Rubycon日本製コンデンサ) | https://auctions.yahoo.co.jp/closedsearch/closedsearch/asus%20p2b/2084039547/ | ¥5,000 | 中古 | 低（日本製コンデンサ） |
| メモリ | PC100 SDRAM 128MB DIMM | https://jp.mercari.com/search?keyword=PC100+128MB+SDRAM | ¥1,000 | 中古 | 低 |
| GPU | NVIDIA Riva TNT 16MB AGP (NV4, Twin Texel) | https://auctions.yahoo.co.jp/closedsearch/closedsearch/riva%20tnt/23336/ | ¥2,500 | 中古 | 低（Creative/Diamond/STB等OEM版も可） |
| サウンドカード | Creative Sound Blaster Live! Value CT4780 PCI (EMU10K1) | https://auctions.yahoo.co.jp/search/search/sound%20blaster%20live/2084039481/ | ¥1,500 | 中古 | 低 |
| ストレージ（アダプタ） | CF-IDE 3.5" 変換アダプター 40ピン | https://www.amazon.co.jp/dp/B097BJX34J | ¥1,200 | 新品 | 低 |
| ストレージ（CF） | コンパクトフラッシュ 8GB | https://www.amazon.co.jp/dp/B0096CGOH6 | ¥2,000 | 新品 | 低 |
| 電源ユニット | ATX 300W新品 | https://www.amazon.co.jp/s?k=ATX電源+300W | ¥4,000 | 新品 | 低 |
| ケース | ATXミドルタワー中古 | https://auctions.yahoo.co.jp/category/list/2084047245/ | ¥2,000 | 中古 | 低 |

**合計: ¥20,000**（確定値）

**MTGクロック対処（PII 300MHz実証済み適正帯の中央値）:**

*コミュニティ動作報告（3件）:*
- **VOGONS** (VIA EPIA 5000): ユーザーdav3ybが「**MTG Shandalarをプレイするため**」にVIA C3 533MHzシステムを構築。「**C3 533MHz ≈ PII 266MHz相当**」→ PII 266MHzがShandalar専用として実際に構築された
- **AnandTech** ("Old Game runs too fast"): ユーザーmitchafiが「**PII 333MHzを組んでShandalarを正しい速度で動かしたい**」→ PII 333MHzが適正速度として選定。PII 300MHzは-10%でより安全
- **AnandTech** (同スレッド Spydermag68): 「**PII 400MHzでプレイ、AIの1手に最大10分だがゲーム速度は正常**」→ 400MHzでも操作可能。300MHzはさらに安全圏

| CPU速度 | MTG動作 | 出典 |
|---------|---------|------|
| PII 266MHz | ✅ VOGONS実証 | VOGONS dav3yb |
| **PII 300MHz** | ✅ **本提案（中央値）** | 266-333の中間 |
| PII 333MHz | ✅ 適正速度選定 | AnandTech mitchafi |
| PII 400MHz | ✅ 操作可能（AI遅延あり） | AnandTech Spydermag68 |
| PIII以上 | ❌ 速すぎ操作不能 | 複数報告 |

**入手戦略（全パーツ国内調達・eBayゼロ）:**
- **CPU (PII 300MHz)**: ヤフオク ¥500-1,500
- **MB (ASUS P2B)**: ヤフオク ¥2,571-8,000（日本製コンデンサ、コンデンサ写真確認必須）
- **GPU (Riva TNT)**: ヤフオク「riva tnt」「viper v330」「3D Blaster」等で検索 ¥1,500-3,000
- **サウンド (SB Live!)**: ヤフオク ¥1,000-1,500。OEM版大量流通
- **ストレージ・電源**: Amazon.co.jp新品即日配送

**リスク評価:**

| リスク | 深刻度 | 軽減策 |
|---|---|---|
| P2B入手価格変動 | 低〜中 | 最安¥2,571。写真確認で日本製コンデンサ個体を選定 |
| Riva TNT入手性 | 低 | Creative/Diamond/STB等OEM版でも可。TNT2が流通多く最悪代替可 |
| PII 300MHzでMTG速すぎ | 極低 | 実証帯中央値。cpukiller3で微調整可 |
| コンデンサ劣化 | 極低 | Nichicon/Rubycon日本製。Capacitor Plague非対象 |

**5ラウンドの軌跡（足軽1号の戦略変遷）:**

| Round | CPU | MB | GPU | 合計 | 結果 |
|---|---|---|---|---|---|
| R1 | PII 350MHz | ASUS P2B | Voodoo3 3000 | ¥36,500 | 74点 |
| R2 | Celeron 433MHz | ASUS CUBX-L | TNT2 M64 | ¥22,500 | 🏆 82点 |
| R3 | PII 333MHz | ABIT BH6 | Matrox G400 | ¥24,000 | 80点 |
| R4 | PII 266MHz | AOpen AX6BC | ATI Rage Pro | ¥17,700 | 77点 |
| R5 | **PII 300MHz** | **ASUS P2B** | **Riva TNT** | **¥20,000** | ← 本提案 |

---

#### 足軽2号 — Round 5提案（最終ラウンド）

**Round 4からの改善点:**
1. **コンデンサ問題の根本解決（R4最大の指摘事項）**: ABIT BH6（台湾製Jackcon/Teapo）→ **ASUS P2B（日本製Nichicon/Sanyo系コンデンサ）**。5ラウンドで繰り返し指摘されたコンデンサ品質問題に最終回答。ASUSフラッグシップ440BXボードで完全解消
2. **CPU+MB完全変更（ルール遵守）**: Celeron 300A + ABIT BH6 → **Celeron 300A + ASUS P2B**
3. **FSB制御の継承**: BH6 SoftMenu III（BIOS 5段階）→ **P2B DIPスイッチ4段階**（66/75/83/100MHz）。物理スイッチの確実性（CMOSクリアで消えない）
4. **コスト6%削減**: ¥20,700 → **¥19,500**。リキャップ予備費が不要になった分で実現
5. **GPU継続（Matrox G200）**: R4で高評価の2D最強ブランドを最終提案にも採用
6. **5ラウンドの知見を統合**: R1の信頼性（ASUS）+ R2/R4の伝説（300A）+ R3の堅実さ（全国内・低コスト）+ R4の雰囲気（OC文化の象徴）を1台に凝縮

**コンセプト**: 「完成形 — Celeron 300Aの伝説をASUS P2Bの信頼性で永遠にする」

5ラウンドの結論: PC自作史上最も有名なCPU「Celeron 300A」を、ASUS最高峰440BXボード「P2B」に載せる。R4で証明した300A+440BXの伝説的組み合わせから、BH6の台湾製コンデンサという唯一の弱点を排除し、日本製コンデンサのASUS P2Bで信頼性を担保する。これが「ロマンと信頼性の両立」という5ラウンドの命題に対する最終回答。

P2Bは「440BXリファレンスデザインの完成形」としてTom's Hardwareレビューで基準ボードに選ばれ、AnandTechが133MHz FSBオーバークロック記事の舞台に選んだ伝説の板。300Aの伝説 × P2Bの伝説 = 1998年PC自作文化の「正史」構成。

| カテゴリ | 型番・製品名 | 入手先URL | 価格（円） | 状態 | リスク評価 |
|---|---|---|---|---|---|
| CPU | Intel Celeron 300A Slot 1 (SL2WM, Mendocino, 300MHz/66MHz FSB) | https://auctions.yahoo.co.jp/search/search/celeron%20300a/23336/ | ¥1,500 | 中古 | 低 |
| マザーボード | ASUS P2B Rev.1.02 (Intel 440BX, Slot 1, ATX, 日本製コンデンサ) | https://auctions.yahoo.co.jp/closedsearch/closedsearch/asus%20p2b/2084039547/ | ¥4,500 | 中古 | 低（日本製コンデンサ） |
| メモリ | PC100 SDRAM 128MB DIMM | https://jp.mercari.com/search?keyword=PC100+128MB | ¥1,000 | 中古 | 低 |
| GPU | Matrox Millennium G200 8MB AGP (MGA-G200A) | https://auctions.yahoo.co.jp/closedsearch/closedsearch/matrox%20g200/2084211538/ | ¥2,000 | 中古 | 低 |
| サウンドカード | Creative Sound Blaster Live! Value CT4780 PCI | https://auctions.yahoo.co.jp/search/search/sound%20blaster%20live/23459/ | ¥1,500 | 中古 | 低 |
| ストレージ（アダプタ） | CF-IDE 3.5" 変換アダプター 40ピン | https://www.amazon.co.jp/dp/B097BJX34J | ¥1,200 | 新品 | 低 |
| ストレージ（CF） | コンパクトフラッシュ 8GB | https://www.amazon.co.jp/dp/B0096CGOH6 | ¥2,000 | 新品 | 低 |
| 電源ユニット | ATX 300W新品 | https://www.amazon.co.jp/s?k=ATX電源+300W | ¥3,500 | 新品 | 低 |
| ケース | ATXミドルタワー中古 | https://auctions.yahoo.co.jp/category/list/2084047245/ | ¥1,800 | 中古 | 低 |
| IDEケーブル予備 | IDE 40pinフラットケーブル | https://www.amazon.co.jp/s?k=IDE+フラットケーブル | ¥500 | 新品 | 低 |

**合計: ¥19,500**

**MTGクロック対処（P2B DIPスイッチ4段階ハードウェア速度制御）:**

*コミュニティ動作報告（5ラウンド蓄積の実証データ）:*
- **VOGONS** (VIA EPIA 5000): ユーザーdav3ybが「**MTG Shandalarをプレイするため**」にVIA C3 533MHzシステムを構築。回答者が「**C3 533MHz ≈ PII 266MHz相当**」と分析。PII 266MHz相当がShandalar用として実際に選ばれた速度帯
- **AnandTech** ("Old Game runs too fast"): ユーザーが「**PII 333MHzを組んでShandalarを正しい速度で動かしたい**」と発言。別ユーザーは「**PII 400MHzではAI手番に最大10分**」= ゲーム速度として適正域
- **VOGONS** (MTG Battlemage): 「**Throttle + CPUKillerの組み合わせが最良**」と複数報告
- **AnandTech** + abandonwaredos: PIII以上で「Shandalarマップが速すぎて操作不能」

*Celeron 300AのMTG適合性:*
Celeron 300A（Mendocino）は128KB on-die L2キャッシュ搭載。Celeron 300MHz ≈ PII 300MHz相当 = Shandalar動作域（266-400MHz）の中央値。

*P2B DIPスイッチ4段階ハードウェア速度制御:*

| FSB設定 | 実効クロック | MTG用途 |
|---------|-------------|---------|
| 66MHz | 300MHz | **定格・動作域中央（推奨開始点）** |
| 75MHz | 337.5MHz | 動作域中央〜上位 |
| 83MHz | 375MHz | 動作域上位 |
| 100MHz | 450MHz | **伝説のOC（SimCity 2000最適・MTGはcpukiller併用）** |

＋cpukiller3で各段階をソフトウェア微調整。DIPスイッチはBIOS設定と異なりCMOSクリアで消えない「物理スイッチの確実性」。

*SimCity 2000対応:* FSB 100MHz → 450MHz設定でSimCity 2000を高速プレイ。MTGに戻すときはDIPスイッチを66MHzに戻すだけ。2つのゲームの速度要件をハードウェアレベルで切り替え可能。

**入手戦略:**
- **全パーツ国内調達（R3から3ラウンド連続）**: ヤフオク/メルカリ/Amazon.co.jpのみ。eBayゼロ
- **CPU (Celeron 300A)**: ヤフオク落札相場¥1,000-4,000。メルカリでジャンク¥300前後の出品もあり
- **MB (ASUS P2B)**: ヤフオク落札相場¥2,571-16,023。流通量多く¥4,500で入手可能。コンデンサ膨張なし個体を写真確認
- **GPU (Matrox G200)**: ヤフオク落札相場¥550-5,000。¥2,000で入手可能
- **サウンド (SB Live!)**: ヤフオク平均¥1,380。OEM品大量流通
- **ストレージ・電源**: Amazon.co.jp新品即日配送

**リスク評価:**

| リスク | 深刻度 | 軽減策 |
|---|---|---|
| P2Bコンデンサ劣化 | **極低** | ASUS = 日本製Nichicon/Sanyo系。BH6(Jackcon/Teapo)比で圧倒的長寿命 |
| P2B動作不安定 | 低 | 440BXリファレンスボード。Win98完全対応の枯れた安定設計 |
| Celeron 300A個体差 | 低 | 定格300MHz使用なら無関係。OC耐性は副次的メリット |
| Matrox G200 Win98ドライバ | 低 | Matrox公式Win98ドライバあり。VOGONS実績多数 |
| P2B入手価格変動 | 低〜中 | 最安¥2,571の実績あり。¥4,500予算で十分な選択肢 |

**5ラウンドの軌跡（足軽2号の戦略変遷）:**

| Round | CPU | MB | コンセプト | 結果 |
|---|---|---|---|---|
| R1 | PII 350MHz | ASUS P3B-F | 信頼性とコスパの両立 | 🏆 79点 |
| R2 | Celeron 300A | 汎用440BX(型番不明) | Celeron 300A伝説 | 76点 ★MB型番不明が致命傷 |
| R3 | PII 350MHz | ASUS P2B-F | 正統派・全国内・最安値 | 🏆 88点 |
| R4 | Celeron 300A | ABIT BH6 | PC自作史上最有名OC | 🏆 83点 ★雰囲気10/10満点 |
| R5 | Celeron 300A | **ASUS P2B** | **完成形: 伝説×信頼性** | ← 本提案 |

---

#### 足軽3号 — Round 5提案（最終ラウンド）

**Round 4からの改善点:**
1. **雰囲気の根本的改革（R4最大敗因: 2/10→目標9/10）**: ATI Rage Pro+CMI8738（OEM量産品の寄せ集め）→ **3dfx Voodoo2 12MB + Matrox Millennium II + Sound Blaster Live!**。1998年のPC雑誌が「最強」と評した3枚のカードを1台に集結。Voodoo2は全5ラウンド・全参加者で誰も選んでいない唯一無二のパーツ
2. **CPU+MB完全変更（ルール遵守）**: AOpen AX6BC+PII 266MHz → **Epox EP-BX3+Pentium II 400MHz**。PII系最速クロックへ大幅アップグレード
3. **コスト最安値追求を完全放棄**: ¥16,500（R4全ラウンド最安値）→ **¥30,200**。雰囲気と技術的完成度に全額投資する最終ラウンドの決断
4. **足軽1号・2号との完全差別化**: CPU（PII 400MHz）・MB（EP-BX3）・GPU（Voodoo2+Millennium II）すべて他参加者と重複なし。5ラウンドで初めて「2D+3Dデュアルビデオカード構成」を提案
5. **「速いCPUをソフトで抑える」→「速いCPUをハードで制御する」**: PII 400MHzをEP-BX3のFSBジャンパで264/300/332/400MHzの4段階に変更可能。R4の「適正速度を選ぶ」思想をさらに発展

**コンセプト**: 「1998年、全てのPCゲーマーが夢見た構成 — Voodoo2 + Pentium II 400MHz + Sound Blaster Live!」

1998年の秋。秋葉原のパーツショップには3dfx Voodoo2のパッケージが山積みされていた。DOS/V POWER REPORT、ASCII、GAME WAVE——あらゆるPC雑誌が「Voodoo2こそ1998年最強の3Dアクセラレータ」と報じ、全てのPCゲーマーが一度は手にしたいと願ったカード。Pentium II 400MHzは1998年のフラッグシップCPU。黒いSlot 1カートリッジに「intel」「PENTIUM II」の金箔ロゴ。その巨大なヒートシンク付きカートリッジを440BXマザーボードのSlot 1に差し込む瞬間は、1998年のPC自作文化における最高の儀式だった。

Sound Blaster Live!は1998年8月にCreative Labsが発売した革命的サウンドカード。Environmental Audio Extensions (EAX)は環境音響効果の概念を一新し、「音が空間を持つ」体験を初めて家庭に届けた。そしてMatrox Millennium II——「2DのMatrox」と呼ばれ、その発色とシャープネスは当時のCRTモニタで他社を圧倒した。

1998年のPC雑誌は繰り返しこう書いた: 「**2DはMatrox、3Dは3dfx、サウンドはCreative。この3枚が揃えば最強。**」本構成はその"伝説の三枚看板"を実現する。Matrox Millennium IIのAGP出力をVoodoo2のVGAパススルーケーブルで接続し、Voodoo2の出力をモニタへ。2Dゲーム（MTG、SimCity 2000）ではMatroxの美麗な2D描画、3DゲームではVoodoo2のGlideアクセラレーション。これが1998年に「全部入り」を組む夢だった。

| カテゴリ | 型番・製品名 | 入手先URL | 価格（円） | 状態 | リスク評価 |
|---|---|---|---|---|---|
| CPU | Intel Pentium II 400MHz (SL2S7, Deschutes, Slot 1, 100MHz FSB) | https://www.ebay.com/itm/225662442102 | ¥1,500 | 中古 | 低 |
| マザーボード | Epox EP-BX3 (Intel 440BX, Slot 1, ATX, FSBジャンパ付き) | https://www.ebay.com/itm/256271787158 | ¥5,000 | 中古 | 中（コンデンサ確認要） |
| メモリ | PC100 SDRAM 128MB DIMM | https://jp.mercari.com/search?keyword=PC100+128MB | ¥1,000 | 中古 | 低 |
| GPU (2D) | Matrox Millennium II 4MB AGP (MGA-2164WA) | https://auctions.yahoo.co.jp/closedsearch/closedsearch/matrox%20millennium/2084211538/ | ¥2,000 | 中古 | 低 |
| GPU (3D) | 3dfx Voodoo2 12MB PCI (Creative CT6670 / IO DATA GA-VDII12等) | https://auctions.yahoo.co.jp/closedsearch/closedsearch/voodoo2/2084211539/ | ¥10,000 | 中古 | 中（入手競争あり） |
| サウンドカード | Creative Sound Blaster Live! Value CT4780 PCI (EMU10K1) | https://auctions.yahoo.co.jp/search/search/sound%20blaster%20live/23459/ | ¥1,500 | 中古 | 低 |
| ストレージ（アダプタ） | CF-IDE 3.5" 変換アダプター 40ピン | https://www.amazon.co.jp/dp/B097BJX34J | ¥1,200 | 新品 | 低 |
| ストレージ（CF） | コンパクトフラッシュ 8GB | https://www.amazon.co.jp/dp/B0096CGOH6 | ¥2,000 | 新品 | 低 |
| 電源ユニット | ATX 300W新品 | https://www.amazon.co.jp/s?k=ATX電源+300W | ¥4,000 | 新品 | 低 |
| ケース | ATXミドルタワー中古 | https://auctions.yahoo.co.jp/category/list/2084047245/ | ¥2,000 | 中古 | 低 |

**合計: ¥30,200**（確定値）

**MTGクロック対処（PII 400MHz FSB 4段階ハードウェア速度制御）:**

*コミュニティ動作報告（5ラウンド蓄積の実証データ）:*
- **VOGONS** (VIA EPIA 5000): ユーザーdav3ybが「**MTG Shandalarをプレイするため**」にVIA C3 533MHzシステムを構築。回答者が「**C3 533MHz ≈ PII 266MHz相当**」と分析。PII 266MHz相当がShandalar用として実際に選ばれた速度帯
- **AnandTech** ("Old Game runs too fast"): ユーザーが「**PII 333MHzを組んでShandalarを正しい速度で動かしたい**」と発言。別ユーザーは「**PII 400MHzではAI手番に最大10分**」= ゲーム速度としては適正域（遅くなるのはAI思考時間のみ）
- **VOGONS** (MTG Battlemage): 「**Throttle + CPUKillerの組み合わせが最良**」と複数報告
- **AnandTech** + abandonwaredos: PIII以上で「Shandalarマップが速すぎて操作不能」→ PII 400MHz以下が安全圏

*PII 400MHz (4× multiplier) × EP-BX3 FSBジャンパ 4段階制御:*

| FSB設定 | 実効クロック | MTG用途 |
|---------|-------------|---------|
| 66MHz | **264MHz** | **Shandalar最適速度（VOGONS実証済みPII 266MHz≒C3 533MHz）** |
| 75MHz | 300MHz | 動作域中央（微調整なしでプレイ可能） |
| 83MHz | 332MHz | 動作域上位（cpukiller微調整推奨） |
| 100MHz | **400MHz** | **定格・SimCity 2000最適（PII最速性能をフル発揮）** |

★**本構成の独自優位性**: PII 400MHzはFSB 66MHzで264MHz——VOGONS実証済みの「PII 266MHz相当」に**ハードウェアレベルで一致**する。他参加者が「定格に近い速度からソフトで下げる」のに対し、本構成は「定格400MHzからハードで下げて264MHzを正確に狙い撃つ」。上にも下にも余裕がある両方向制御。

＋cpukiller3で各段階をさらにソフトウェア微調整。FSBジャンパは物理的設定のため、CMOSクリアで消えない確実性。

*SimCity 2000対応:* FSB 100MHz → 400MHz（PII最速性能）でSimCity 2000を高速プレイ。MTGに戻すときはFSBジャンパを66MHzに切り替えるだけ。「1998年のフラッグシップ速度」と「MTG最適速度」をハードウェアレベルで使い分け。

**Voodoo2 + Matrox Millennium II デュアルビデオカード構成の詳細:**

接続構成: Matrox Millennium II (AGP) → VGA出力 → Voodoo2 (PCI) パススルー入力 → Voodoo2 VGA出力 → モニタ

- **2Dモード（MTG、SimCity 2000、デスクトップ）**: Matrox Millennium IIが描画。Voodoo2は信号をパススルーするだけ。Matroxの伝説的2D画質でMTGのカードアートを美しく表示
- **3Dモード（Glide対応ゲーム）**: Voodoo2が自動的にレンダリングを引き継ぎ。Quake II、Unreal等の3Dゲームにも対応可能
- **MTGへの影響**: MTGは100% 2Dゲーム → Voodoo2は描画に関与しない。Matrox Millennium IIの2D性能がそのまま活きる

この「2D専用カード + 3D専用カード」の分業は1998年のPCゲーミングにおける最も洗練されたセットアップであり、当時のPC雑誌で繰り返し推奨された構成。

**入手戦略:**
- **CPU (PII 400MHz)**: eBayで$10-20（¥1,500）。Deschutes PII 400は中古市場に大量流通。eBay送料込みで¥2,000以内で入手可能
- **MB (Epox EP-BX3)**: eBayで$25-50（¥4,000-7,500）。eBay listing確認済み。EP-BX3は日本ではProNiXブランドで販売されていた440BX名板
- **GPU 2D (Matrox Millennium II)**: ヤフオク落札相場¥1,000-3,000。Matroxカードは日本市場での流通量多い
- **GPU 3D (Voodoo2 12MB)**: ヤフオク落札相場¥7,700-39,210、平均¥16,945。¥10,000は下位30%価格帯だが、IO DATA GA-VDII12やCreative CT6670等の日本国内流通モデルを狙えば十分到達可能。入手に1-2週間のウォッチリスト監視を推奨
- **サウンド (SB Live! CT4780)**: ヤフオク¥451-1,480で大量流通。OEM品（Dell/HP/NEC等）含め在庫豊富
- **ストレージ・電源**: Amazon.co.jp新品即日配送

**リスク評価:**

| リスク | 深刻度 | 軽減策 |
|---|---|---|
| Voodoo2入手難度（最大のリスク） | 中 | ヤフオク月7件出品実績あり。IO DATA/Creative等の日本モデルを優先。予算¥10,000-15,000で柔軟に対応 |
| Voodoo2動作不良 | 低〜中 | 動作確認済み出品を優先。PCI接続で相性問題少ない。Win98環境で3dfxドライバ完全対応 |
| EP-BX3コンデンサ劣化 | 中 | 購入前写真でコンデンサ膨張確認。Epoxは台湾メーカーだがEP-BX3世代は品質安定期。¥2,000リキャップ予備費を想定 |
| PII 400MHz FSB下げ安定性 | 極低 | 440BXは66/100MHz FSBをネイティブサポート。66MHzは定格動作であり不安定化リスクなし |
| Matrox MillenniumII + Voodoo2パススルー相性 | 低 | 1998年当時の定番組み合わせ。VOGONS/PhilsComputerLabで多数の実績報告 |
| 総コスト¥30,200 | — | 最終ラウンドの「夢構成」として受容。雰囲気スコア2/10→9/10の改善で十分なリターン |

**5ラウンドの軌跡（足軽3号の戦略変遷）:**

| Round | CPU | MB | GPU | 合計 | 結果 |
|---|---|---|---|---|---|
| R1 | PII 350MHz | ASUS P2B-B | Voodoo3 3000 | ¥26,000-38,000 | 68点（最下位） |
| R2 | Celeron 466MHz | ASUS CUSL2 (815E) | TNT2 M64 | ¥32,042 | 68点（最下位） |
| R3 | PII 333MHz | ABIT BH6 | Matrox G400 | ¥23,500 | 72点（最下位） |
| R4 | PII 266MHz | AOpen AX6BC | ATI Rage Pro | ¥16,500 | 77点（2位タイ） |
| R5 | **PII 400MHz** | **Epox EP-BX3** | **Voodoo2+Millennium II** | **¥30,200** | ← 本提案 |

R1-R3: 構成の差別化不足と時代感のズレで苦戦。R4: コスト最安値¥16,500を達成するも雰囲気2/10が足枷。R5: 最終ラウンドで戦略を180度転換——コスト度外視で「1998年の夢」を追求。0勝の名誉回復を賭けた、5ラウンド最大の賭け。

---

#### 軍師評価

**評価日:** 2026-03-19

| 参加者 | コンセプト | MTG互換(30) | 安定性(25) | コスト(20) | 入手性(15) | 雰囲気(10) | **合計** |
|---|---|---|---|---|---|---|---|
| 🏆 足軽2号 | 完成形: 300A×P2B | 28 | 24 | 16 | 13 | 9 | **90** |
| 足軽1号 | Reviewer's Reference | 27 | 23 | 15 | 12 | 8 | **85** |
| 足軽3号 | Voodoo2+Millennium II夢構成 | 26 | 16 | 8 | 9 | **10** | **69** |

**Round 5 優勝: 足軽2号（90点）** — 全5ラウンド最高スコア。300A+P2Bの「伝説×信頼性」完成形。

**注目点:**
- 全3名が完全に異なる構成を提出（5ラウンドで初の構成重複ゼロ）
- 足軽2号 90点は全コンペ最高スコア（従来最高R3の88点を更新）
- 足軽3号のVoodoo2+Millennium IIデュアルビデオは全コンペ唯一の構成。雰囲気10/10
- 足軽1号のRiva TNTは全コンペ唯一。NVIDIAの歴史的GPU

詳細評価: queue/reports/gunshi_report.yaml 参照

---

## 最終結果

### 通算成績

| 参加者 | R1 | R2 | R3 | R4 | R5 | 優勝回数 | 通算平均 |
|---|---|---|---|---|---|---|---|
| **🏆 足軽2号** | 🏆79 | 76 | 🏆88 | 🏆83 | 🏆**90** | **4勝** | **83.2** |
| 足軽1号 | 74 | 🏆82 | 80 | 77 | 85 | 1勝 | 79.6 |
| 足軽3号 | 68 | 68 | 72 | 77 | 69 | 0勝 | 70.8 |

### 🏆 総合優勝: 足軽2号（通算4勝・平均83.2点）

**殿への最終推薦構成: 足軽2号 R5 — Celeron 300A + ASUS P2B + Matrox G200 + SB Live! = ¥19,500**

---

## 合議結果 — 3部門推薦構成（cmd_261）

合議日: 2026-03-19（3フェーズ制）
参加者: 足軽1号・足軽2号・足軽3号・軍師（評価者）

### 【安心部門】定格安定・日本製コンデンサ・枯れたドライバ

OC誘惑ゼロの定格運用で、何も考えずに安心してMTGが遊べる構成。

| カテゴリ | パーツ | 投票 | 価格 |
|----------|--------|------|------|
| CPU | **Intel Pentium II 350MHz (Deschutes, Slot 1)** | 3:1 多数決 | ¥1,500 |
| MB | **ASUS P2B (Intel 440BX, Rev.1.02以降)** | 4:0 全員一致 | ¥5,000 |
| GPU | **Matrox Millennium G200 8MB AGP** | 3:1 多数決 | ¥2,000 |
| サウンド | **Creative SB Live! Value CT4780 (EMU10K1)** | 4:0 全員一致 | ¥1,200 |
| **合計** | | | **≈¥9,700** |

選定理由: PII 350MHzはMTG実証域（266-400MHz）の中央やや上で定格安定。300Aと異なりOCの伝説がなく「安心」の趣旨に合致。P2Bは日本製Nichicon/Rubyconコンデンサの440BXリファレンス完成形。G200は2D描画最高峰でMTG（2Dゲーム）に最適。

### 【実現部門】国内1ヶ月以内に全パーツ調達可能

ヤフオク・メルカリ・じゃんぱら等の国内プラットフォームで確実に入手できる構成。

| カテゴリ | パーツ | 投票 | 価格 |
|----------|--------|------|------|
| CPU | **Intel Pentium II 300MHz (Deschutes, Slot 1)** | 3:1 多数決 | ¥800 |
| MB | **ASUS P2B (Intel 440BX)** | 3:1 多数決 | ¥5,000 |
| GPU | **Matrox Millennium G200 8MB AGP** | 2:1:1 評価者確定 | ¥2,000 |
| サウンド | **Creative SB Live! Value CT4780** | 4:0 全員一致 | ¥1,000 |
| **合計** | | | **≈¥8,800** |

選定理由: PII 300MHzはSlot 1 CPU中で最流通量・最安価格帯。P2Bは440BX系で出品数最多。G200は入手性・MTG用途適合性・コスト安定性の3基準で最適と評価者が判断。GPUは2:1:1の分裂（G200/TNT2 M64/G400）だったが、最多得票+評価者判断でG200に確定。

### 【ロマン部門】1998年、全PCゲーマーが夢見た構成の完全再現

Celeron 300A+BH6のOC伝説 × Voodoo2+Millennium IIの2D/3D分離 × YMF744のMIDI音源。

| カテゴリ | パーツ | 投票 | 価格 |
|----------|--------|------|------|
| CPU | **Intel Celeron 300A (Mendocino, Slot 1, SL2WM)** | 4:0 全員一致 | ¥2,000 |
| MB | **ABIT BH6 (Intel 440BX, SoftMenu III)** | 4:0 全員一致 | ¥3,500 |
| GPU (3D) | **3dfx Voodoo2 12MB PCI** | 3:1 多数決 | ¥12,000 |
| GPU (2D) | **Matrox Millennium II 4MB AGP** | (デュアル構成) | ¥2,000 |
| サウンド | **Yamaha YMF744B-V PCI** | 3:1 多数決 | ¥2,500 |
| **合計** | | | **≈¥22,000** |

選定理由: 300A+BH6はPC自作史上最も有名なOCコンボ。SoftMenu IIIでFSB 66→100MHzに設定すれば300→450MHzに覚醒する物語性。「2DはMatrox、3Dは3dfx」は1998年PC自作文化の頂点であり、この2枚を並べた瞬間に当時の空気が蘇る。YMF744はハードウェアXG MIDI音源内蔵で、MTGのMIDI BGMが段違いの音質で鳴る通好みの逸品。

### 合議プロセス総括

| フェーズ | 内容 | 成果 |
|----------|------|------|
| Phase 1 | 各自が独立に振り返り・暫定推薦を提出 | 12パーツ中4パーツが初回全員一致（MB×2・サウンド×2） |
| Phase 2 | 他者の意見を読み最終推薦を提出 | 大幅収束→11/12パーツが3:1以上で確定 |
| Phase 3 | 最終確認・評価者承認 | 実現GPUをG200に確定。全12パーツ合意完了 |

**合議の特徴**: 全参加者がフェーズ2で他者の論拠を受けて意見を修正する柔軟性を示した。特に足軽3号のロマンCPU変更（PII 400→300A）と足軽1号のCPU入替え（安心=300A→実現=PII300）は合議による集合知の好例。ロマン部門は全員一致2項目を含み最も美しく収束した部門。
