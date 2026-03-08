---
name: update-shogun
description: |
  multi-agent-shogunリポジトリをupstream (yohey-w/multi-agent-shogun) から更新する。
  変更点の説明・ローカルカスタマイズとの矛盾点検・解決方針の提案を行ったうえで取り込む。
  「更新」「アップデート」「upstream」「本家」「取り込み」で起動。
argument-hint: "[--dry-run]"
disable-model-invocation: true
allowed-tools: Read, Bash, Edit, Grep, Glob
---

# update-shogun: upstream追従スキル

## 目的

multi-agent-shogunをupstream/main (yohey-w/multi-agent-shogun) に追従させる。
殿のローカルカスタマイズを安全に保持しつつ、本家の改善を取り込む。

## リモート構成

| リモート | リポジトリ | 役割 |
|----------|-----------|------|
| upstream | yohey-w/multi-agent-shogun | 本家（読み取り専用） |
| origin | LitMc/multi-agent-shogun | fork（殿のカスタマイズ） |

## 現在の状態

!`cd /Users/jgoto/multi-agent-shogun && git fetch upstream 2>/dev/null && echo "=== Current branch ===" && git branch --show-current && echo "=== Upstream behind count ===" && git rev-list HEAD..upstream/main --count && echo "=== New upstream commits ===" && git log --oneline HEAD..upstream/main 2>/dev/null | head -20 && echo "=== Local uncommitted changes ===" && git diff --stat 2>/dev/null | tail -5`

## 手順

### Step 1: 差分確認

1. `git fetch upstream` で最新情報を取得
2. `git rev-list HEAD..upstream/main --count` で未取り込みコミット数を確認
   - **0件なら「最新です」と報告して終了**
3. `git log --oneline HEAD..upstream/main` で全コミットを一覧表示

### Step 2: 変更点サマリの作成

殿に以下を **日本語で簡潔に** 説明する:

1. **何が変わったか**: 各コミットの意図を機能カテゴリ別にまとめる
   - 新機能 / バグ修正 / リファクタ / ドキュメント / CI/CD
2. **影響範囲**: 変更されたファイル・ディレクトリを `git diff --stat HEAD..upstream/main` で確認
3. **重要度**: 取り込まないとどうなるか（セキュリティ修正なら緊急、等）

```bash
# 変更ファイル一覧
git diff --stat HEAD..upstream/main
# 変更の詳細（大きい場合はファイル単位で確認）
git diff HEAD..upstream/main -- <file>
```

### Step 3: ローカルカスタマイズとの矛盾点検

**これがこのスキルの最重要ステップ。**

1. **ローカル独自コミットの特定**:
   ```bash
   # upstreamにないローカル独自コミット
   git log --oneline upstream/main..HEAD
   ```

2. **矛盾ファイルの検出**:
   ```bash
   # 両方が変更したファイル（矛盾の可能性あり）
   comm -12 \
     <(git diff --name-only HEAD..upstream/main | sort) \
     <(git diff --name-only upstream/main..HEAD | sort)
   ```

3. **矛盾ファイルごとに以下を判定**:

   | 判定 | 状況 | 例 |
   |------|------|-----|
   | ✅ 両立可能 | 変更箇所が異なる | upstream: 新関数追加、local: 別関数の修正 |
   | ⚠️ 要検討 | 同じ箇所を異なる意図で変更 | upstream: デフォルト値変更、local: 同じ値を別の値に変更 |
   | ❌ 矛盾 | 相互排他的な変更 | upstream: ファイル削除、local: 同ファイルに機能追加 |

4. **矛盾がある場合、以下の方針を提案**:
   - **(A) upstream優先**: 本家の設計思想に合わせる（ローカル変更を捨てるか再実装）
   - **(B) local優先**: 殿の運用に必要なカスタマイズを維持（upstreamの変更を部分的に取り込む）
   - **(C) 統合**: 両方の意図を活かした新しい実装を作る
   - **(D) 分離**: 矛盾するファイルはローカル専用として `.gitignore` に退避

   **一辺倒は禁止**: 「全部upstream」「全部local」ではなく、ファイルごとに最善を判断する。

### Step 4: 殿の承認

`$ARGUMENTS` に `--dry-run` が含まれる場合は **ここで終了**（Step 2-3の報告のみ）。

それ以外の場合、矛盾点検結果と方針提案を殿に提示し、承認を待つ。
**殿の承認なしにマージを実行してはならない。**

### Step 5: マージ実行

1. **ローカル変更の退避**（未コミット変更がある場合）:
   ```bash
   git stash push -m "update-shogun-$(date +%Y%m%d_%H%M%S)"
   ```

2. **マージ**:
   ```bash
   git merge upstream/main
   ```

3. **コンフリクト発生時**:
   - `git diff --name-only --diff-filter=U` でコンフリクトファイルを特定
   - Step 3で決めた方針に従って各ファイルを解決
   - 解決後: `git add <file>` → `git commit`

4. **stash復元**（退避した場合）:
   ```bash
   git stash pop
   ```

### Step 6: 検証

```bash
# マージ後の状態確認
git log --oneline -5
git status
```

- upstreamのコミットが取り込まれていることを確認
- ローカルカスタマイズが保持されていることを確認

### Step 7: 報告

以下を殿に報告する:

1. **取り込み結果**: コミット数・主な変更内容
2. **矛盾解決**: あった場合、どう解決したか
3. **カスタマイズ保持状況**: ローカル独自変更が維持されているか
4. **次のアクション**: origin pushが必要か、動作確認が必要か

## コンフリクト解決の原則

| 状況 | 方針 |
|------|------|
| upstream: バグ修正・セキュリティ修正 | **upstream優先**（安全性最優先） |
| upstream: 新機能追加 + local: 同ファイル修正 | 両方統合（upstream構造にlocal変更を再適用） |
| upstream: 構造変更 + local: 内容変更 | upstream構造を採用、localの内容を移植 |
| upstream: デフォルト値変更 + local: 同値をカスタマイズ | **殿に確認**（運用影響あり） |
| local: ntfy設定・instructions調整等の運用カスタマイズ | **local優先**（殿の環境固有） |

## 注意事項

- このスキルは副作用があるため `disable-model-invocation: true`（手動 `/update-shogun` でのみ起動）
- config/, queue/, context/, projects/ など `.gitignore` 対象の運用データはマージに影響しない
- stashが残った場合は `git stash list` で確認可能
- **origin push は殿の指示があるまで行わない**
