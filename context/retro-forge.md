# retro-forge プロジェクトコンテキスト
最終更新: 2026-03-26 (cmd_299 リポジトリ分離)

> **詳細ドキュメントは https://github.com/LitMc/retro-forge を参照**
> パーツリスト、購入ガイド、コンペ結果、審議記録等は専用リポジトリに移行済み。
> ローカルパス: /Users/jgoto/ghq/github.com/LitMc/retro-forge

## 基本情報
- **プロジェクトID**: retro-forge
- **正式名称**: Retro Forge — レトロゲーム仮想化環境構築
- **パス**: 未定（仮想環境構築のためホスト側の作業が中心）

## 概要
Windows 98時代のレトロゲーム（MicroProse版Magic: The Gathering等）を現代PC環境で快適にプレイするための仮想化環境を構築する。

## 背景・動機
- 2021年頃にVMware PlayerでWindows 98環境を構築し、MicroProse版MTGの動作に成功
- しかし以下の問題で断念:
  1. **CPUクロック依存問題**: ゲームスピードがCPUクロックに依存しており、現代CPUでは速すぎて操作不能
  2. **VMware Playerの制限**: CPUクロック制御の設定項目がない
  3. **AMD環境の不安定さ**: Ryzen 7950Xでの動作が不安定
  4. **ESXi構築失敗**: CPUクロック調整が可能なESXiを試みたが、基盤ソフトウェアのインストールに失敗
- 今回リベンジしたい

## ホスト環境
- **CPU**: AMD Ryzen 9 7950X
- **GPU**: NVIDIA RTX 4090
- **OS**: Windows 11
- **前回使用**: VMware Workstation Player

## 対象タイトル
| タイトル | プラットフォーム | 備考 |
|----------|------------------|------|
| Magic: The Gathering (MicroProse, 1997) | Windows 98 | 主目標。CPUクロック依存でゲーム速度が異常 |
| Might and Magic VI: The Mandate of Heaven (1998) | Windows 95/98 | GrayFace Patch適用推奨。ソフトウェアレンダリング専用（GPU非依存） |
| SimCity 2000 | Windows 95/98 | 追加候補 |

## 技術的課題
1. **CPUクロック制御**: ゲームがリアルタイムクロックではなくCPUサイクルでタイミングを取っている
   - 解決候補: ESXi、QEMU/KVM（cpu throttle）、DOSBox系、cpukiller的アプローチ
2. **仮想化プラットフォーム選定**: VMware vs QEMU/KVM vs Hyper-V vs ESXi vs その他
3. **AMD Ryzen互換性**: 仮想化支援機能（AMD-V/SVM）との相性
4. **GPU パススルー**: 必要に応じてGPUパススルーの検討
5. **Windows 98ドライバ**: 仮想環境向けドライバの確保

## 調査すべき選択肢
- [x] **QEMU (Windows 11ホスト)**: `-icount shift=N` で命令レベルCPU速度制御可能 → 推奨度: 高
- [x] **DOSBox-X**: Win98サポートあり。`cycles=fixed XXXX` でCPUサイクル固定 → 推奨度: 高
- [x] **86Box**: 実機CPUクロックをそのまま設定（Pentium 166MHz等）→ 推奨度: 高（最有力）
- [x] **PCem**: 86Boxの下位互換。開発停滞。選ぶ理由なし → 推奨度: 低
- [x] **VMware Workstation Pro**: CPU速度制御が不可能（アーキテクチャ上の制約）→ 推奨度: 低
- [x] **ESXi on Ryzen 7950X**: CPUサイクル制御が不十分、非公式サポート → 推奨度: 中（セカンドオプション）
- [x] **cpukiller / BES**: DOSBox-X使用なら不要。VMware使用時のみ緩和策として有効
- [ ] **Retroarch + RetroPC系コア**: 未調査

---

## 技術調査結果（cmd_258, 2026-03-18）

### 仮想化プラットフォーム比較表

| プラットフォーム | Win98安定性 | CPU速度制御 | DirectDraw | AMD Ryzen互換 | セットアップ難易度 | 推奨度 |
|---|---|---|---|---|---|---|
| **86Box** | ◎良好 | ◎ 実機CPUクロック設定（4.77MHz〜733MHz）| ◎ 3dfx Voodoo3エミュ対応 | ◎ 問題なし | 中 | **★最推奨** |
| **DOSBox-X** | ○良好 | ◎ `cycles=fixed XXXX` でリアルタイム調整可 | ○ DirectDraw対応 | ◎ 問題なし | 中 | **★推奨** |
| **QEMU (Win11)** | ○良好 | ◎ `-icount shift=N` で命令レベル制御 | ○ SoftGPUで対応可 | ◎ CPU非依存 | 中（CLI中心）| **★推奨** |
| **VMware Pro** | ○良好 | ✕ 不可能（アーキテクチャ上の制約）| ○ DirectDraw基本動作 | △ patcher9x要 | 低 | 非推奨 |
| **ESXi** | △可能 | △ CPUスケジューリング制限のみ（効果薄）| △ 基本2Dのみ | △ 非公式ワークアラウンド要 | 高 | 条件次第 |
| **PCem** | ○対応 | ◎ 実機クロック設定可 | ○ | ○ | 高 | 低（86Box推奨）|

### 推奨構成（第1候補・第2候補）

#### 第1候補: 86Box（最も確実）
- **理由**: 実機CPUクロック（例: Pentium 166MHz）をそのまま設定できるため、MTGの速度問題を根本解決できる
- **Win98 SE動作**: 実績多数。3dfx Voodoo3 3000エミュレーション対応でDirectDraw加速も可能
- **最新版**: v5.3（2025年12月21日）、活発開発中
- **注意**: VM再起動なしのon-the-flyクロック変更は将来実装予定（現在は設定後再起動必要）
- **URL**: https://86box.net/

#### 第2候補: DOSBox-X（最も手軽）
- **理由**: `cycles=fixed 5000` 等で即座にCPUサイクルを固定。`Ctrl+F11/F12` でリアルタイム微調整可能
- **Win98 SEセットアップ**: 公式ガイドが充実（dosbox-x.com/wiki/Guide:Installing-Windows-98）
- **補足**: VM環境構築せずに `Shandalar 2012 Revisited` パッチをまず試す方が最も手軽

#### 第3候補: QEMU（技術的に優秀だが学習コスト高）
- **理由**: `-icount shift=N` でDOSBoxのcycles制御に近い命令レベル制御が可能
- **注意**: `-icount` はTCGモード（KVM/WHPX無効）のみ使用可能
- **起動例**: `qemu-system-i386 -m 512 -hda win98.qcow2 -icount shift=5,align=off,sleep=on`

### CPU速度制御ツール（ゲスト側・補助用）

| ツール | 用途 | 現在の入手性 | 推奨場面 |
|---|---|---|---|
| **cpukiller3** | CPU使用率0-100%で調整 | ◎ 入手可（v1.0.7.8, 2025年10月）| VMware使用時のゲスト側緩和策 |
| **BES** | プロセス単位でCPU使用率制限 | ◎ 入手可（v1.7.10, Win11対応）| VMware使用時のホスト側緩和策 |
| **patcher9x** | AMD Ryzen上でWin98 VMが動かないバグの修正パッチ | ◎ GitHub公開中（v0.6.14）| VMware Pro / VirtualBoxでRyzen上Win98を動かす際に必須 |

---

## ゲームタイトル別推奨動作方法

### Magic: The Gathering (MicroProse, 1997) — 通称 Shandalar

**コミュニティ版:**
- **2010 Edition** (CCGHQ): 最新のコミュニティ更新版。Windows 7以降対応、カード2000枚超、解像度拡張対応
  - DL: https://archive.org/details/MagicTheGathering2010Edition
  - コミュニティ: https://slightlymagic.net/forum/viewforum.php?f=76

**速度問題の対処法（優先順位順）:**
1. **86Boxで実機CPUクロック設定**（Pentium 166-233MHz相当）→ 最も確実な根本解決
2. **DOSBox-X + cycles=fixed** → 最も手軽、リアルタイム微調整可能
3. **QEMU + -icount shift=N** → 命令レベル制御
4. **Shandalar 2012 Revisited パッチ** → Win XP〜10対応の互換性パッチ（速度問題の完全解決ではないが試す価値あり）

**入手方法:**
- GOG/Steam: なし（販売されていない）
- abandonware: My Abandonware, Internet Archive で配布
- 公式パッチ: v1.1, v1.25 (Internet Archive)

### SimCity 2000

**速度問題**: あり（Cheetah速度で災害が速すぎる程度。MTGほど深刻ではない）

**推奨プレイ方法（優先順位順）:**
1. **GOG版 + DOS2WINパッチ + sc2kfix Release 10** → 最も手軽（仮想化不要）
   - GOG: https://www.gog.com/en/game/simcity_2000_special_edition
   - DOS2WIN: https://community.pcgamingwiki.com/files/file/2738-simcity-2000-dos2win/
   - sc2kfix: https://sc2kfix.net/ (最新: Release 10, 2025年12月24日)
2. **86Box / 仮想環境** → MTG用に86Box構築済みなら同環境でそのまま動作

---

## ハードウェア調査結果（実機構築）

### 1998〜2000年代の典型的ゲーミングPC構成

| カテゴリ | 当時の主流 | 備考 |
|---|---|---|
| CPU (1998) | Intel Pentium II 350-400MHz (Slot 1) | Celeron 300AのOCも人気 |
| CPU (1999-2000) | Intel Pentium III 450-800MHz (Socket 370) | AMD Athlon 700MHz-1GHzも台頭 |
| GPU (1997-98) | 3dfx Voodoo2 (SLI対応, 8-12MB) | 3D専用。2Dカード(Matrox等)も必要 |
| GPU (1999) | 3dfx Voodoo3 2000/3000 / NVIDIA Riva TNT2 | Voodoo3は24bit非対応が弱点 |
| GPU (1999末-2000) | NVIDIA GeForce 256 / GeForce2 MX | 3dfxはNVIDIAに買収され消滅（2000年12月） |
| マザーボード | Intel 440BX (Slot 1) → Intel 815 (Socket 370) | 440BXが最も安定 |
| メモリ | PC100/PC133 SDRAM 64-128MB | Win98は64MBで快適 |
| サウンド | Creative SB Live! (PCI) / Yamaha YMF744 (PCI) | YMF744はDOS互換性が良くコスパ良好 |
| ストレージ | IDE HDD 4-20GB | 137GB問題はこの時代は無関係 |
| OS | Windows 98 SE (1999年6月) | 最も安定したレトロゲーミングOS |

**GPU勢力図（1997-2000）:**
- 3dfx王朝 (1996-1998) → 群雄割拠 (1998-1999) → NVIDIA天下 (1999-) → 3dfx消滅 (2000年12月)
- ATI本格参入はRadeon（2000年）から

**日本の情報源:** DOS/V POWER REPORT（インプレス）、DOS/V MAGAZINE（ソフトバンク）、月刊アスキー

### 現代（2026年）での実機構築可能性

| パーツ | 入手性 | 価格相場（USD） | リスク |
|---|---|---|---|
| CPU (Pentium III Socket 370) | ◎ | $10-30 | 低（壊れにくい）|
| マザーボード (Socket 370) | ○ | $30-100 | **高（コンデンサ劣化）**|
| GPU (NVIDIA Riva TNT2) | ◎ | $15-50 | 低 |
| GPU (3dfx Voodoo3) | ○ | $30-70 | 低（コレクター市場）|
| サウンド (SB Live!) | ◎ | $10-30 | 低 |
| PC100/133 SDRAM 128MB | ◎ | $5-15 | 低 |
| ストレージ | ◎ | $20 (CF-IDE変換推奨) | IDEのHDDは高リスク。CF変換推奨 |

**コンデンサ劣化（Capacitor Plague）について:**
- 1999-2003年製マザーボードに多発した電解コンデンサ不良品問題
- 膨張・液漏れにより動作不安定→起動不能
- 対策: 購入前に写真確認 / リキャップ済み品を選ぶ

### 推奨実機構成案

**コンセプト重視案（$200-350 / 約30,000-52,000円）:**
- CPU: Intel Pentium II 350-400MHz (Slot 1)
- MB: Intel 440BX Slot 1マザー (ASUS P2B等)
- GPU: 3dfx Voodoo3 2000/3000 AGP
- Sound: Yamaha YMF744カード
- RAM: 128MB PC100 SDRAM
- Storage: CF-IDE変換 + 8GB CF（HDD不要で信頼性向上）

**★重要★ MTGのCPUクロック問題は実機でも発生する**
- Pentium III 500MHz以上だと速すぎる可能性あり
- 実機構築するなら**あえてPentium II 300-400MHz**を選ぶか、cpukillerで対応が必要
- → **「CPUクロック制御のしやすさ」では仮想化（86Box/DOSBox-X）の方が圧倒的に有利**

**実機構築の総合評価:**
- コスト: $100-350（パーツのみ）、手間: 高、信頼性リスク: 中〜高
- 「レトロPC趣味として楽しみたい」場合は価値あり
- 主目的（MTGプレイ）なら**まず仮想化で動作確認→気に入れば実機構築**の段階的アプローチを推奨

---

## 重要な決定事項

| 決定項目 | 決定内容 | 根拠 |
|---|---|---|
| **第1推奨プラットフォーム** | **86Box** | 実機CPUクロック設定がMTG速度問題の根本解決になる |
| **第2推奨プラットフォーム** | **DOSBox-X** | cycles設定が最も手軽で直感的 |
| **VMware Pro** | 非推奨（CPUサイクル制御不可） | アーキテクチャ上の制約。殿の前回失敗と同じ問題 |
| **ESXi** | セカンドオプション（条件次第）| Ryzen 7950Xは非公式サポート、CPUサイクル制御が不十分 |
| **SimCity 2000** | sc2kfix + GOG版で仮想化不要 | 速度問題がMTGほど深刻でなく、ネイティブで解決可能 |
| **実機構築** | 趣味として検討可、主目的には非推奨 | CPUクロック制御が仮想化より難しい |

## マイルストーン
- **Phase 1**: 技術調査・プラットフォーム選定
- **Phase 2**: 環境構築
- **Phase 3**: ゲーム動作検証・速度調整
- **Phase 4**: 追加タイトル対応

## 進行状況
- [x] プロジェクト発足 (2026-03-18)
- [x] 仮想化プラットフォーム調査 (cmd_258, 2026-03-18)
- [x] ハードウェア（実機）調査 (cmd_258, 2026-03-18)
- [x] 光学ドライブ・FDD調査 (cmd_305, 2026-03-27)
- [x] CPUクロック・スイートスポット調査 (cmd_306, 2026-03-27)
- [ ] 環境構築（Phase 2）
- [ ] MicroProse MTG 動作確認
- [ ] ゲーム速度の最適化

## 注意事項
- Windows 98のインストールメディア・ライセンスは殿が所有済み（前回使用実績あり）
- ゲームソフトの入手手段: abandonware（My Abandonware, Internet Archive）で入手可能（権利関係は複雑）
- **次のアクション（Phase 2）**: 86BoxまたはDOSBox-Xをインストールし、Win98 SEをゲストOSとして構築する
