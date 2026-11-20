# Markdownの文章検査

`check_md_lines.py`は、1行への情報の詰め込みを検査します。
`mht-zaiko`の同名スクリプトから移植しました。
検査基準の数値はスクリプト先頭の定数だけに持ちます。

## 手動で実行する

リポジトリのルートで実行します。

```sh
python3 tools/check_md_lines.py AGENTS.md tools/README.md
```

- Git管理中のファイルは、最後のコミットから変更した行を検査します。
- 新しいファイルは全行を検査します。
- コードブロックと見出しは検査しません。
- 表のセルは、`<br>`で分けた区切りごとに検査します。
- 問題があると、ファイル名・行番号・修正のヒントを表示します。
  終了コードは`2`です。

## Codexで自動検査する

設定は`.codex/hooks.json`の`PostToolUse`です。
`apply_patch`とシェル操作の後に実行します。
Gitの変更一覧からMarkdownを探すため、シェル経由の編集にも対応します。
ステージ済みの変更と、Git管理外の新規ファイルも対象です。
Gitで無視される新規ファイルは対象外です。
チャットの返事は自動検査の対象外です。

初回はCodexでhookを確認し、信頼する操作が必要です。
CLIでは`/hooks`、デスクトップでは「Settings > Hooks」を開きます。
設定を変更した場合も、再度確認してください。

## 検査スクリプトのテスト

Python標準の`unittest`を使います。

```sh
python3 -m unittest discover -s tools -p 'test_*.py'
```
