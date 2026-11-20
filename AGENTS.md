# Repository Guidelines

## ディレクトリ構成とモジュール

個人用のNeovim設定リポジトリです。主にmacOSで使用し、WSLにも対応しています。

- `init.lua`：deinの初期化とLSP設定の選択。`vscode/`はVSCode Neovim用の起動処理です。
- `toml/`：プラグイン、依存関係、遅延ロード条件、設定フックを定義します。
- `lua/config/`：エディタ全体の設定。`lua/plugins/`は用途別のプラグイン設定、`lua/utils/`は共通処理です。
- `autoload/`：Vimscriptの共通処理とプラグイン連携。`after/ftplugin/`はファイルタイプ別の設定です。
- `denops/gitInfo/`：TypeScriptによるGit情報の取得処理です。
- `ultisnips/`、`scripts/`、`docs/`：スニペット、環境別の補助スクリプト、保守メモを配置します。

## 開発・確認用コマンド

ビルドは不要です。
Neovim、Git、Deno、Node.js、ripgrep、Python 3を事前にインストールしてください。

- `nvim`：このリポジトリを`~/.config/nvim`に配置して起動します。未導入のプラグインは起動時にインストールされます。
- `LSP_PLUGIN_SELECTION=2 nvim`：Mason/LSPConfigを選択します。既定値はcoc.nvimを使う`1`です。
- `:call dein#recache_runtimepath()`：プラグイン定義やLSPの選択を変更した後に、deinのキャッシュを更新します。
- `deno check denops/gitInfo/main.ts`：Denopsの起点ファイルを型チェックします。リモート依存の初回取得にはネットワーク接続が必要です。
- `git diff --check`：提出前に空白の不備を確認します。
- `python3 tools/check_md_lines.py AGENTS.md`：Markdownの変更行を検査します。
- `python3 -m unittest discover -s tools -p 'test_*.py'`：検査スクリプトをテストします。

## コーディングスタイルと命名

`.editorconfig`に従い、UTF-8、LF改行、スペース2文字のインデント、ファイル末尾の改行を使用します。Markdownでは行末の空白を許可しています。

周囲のLua・Vimscriptの書き方に合わせてください。
Luaの関数名は`snake_case`を使用します。
ファイル名は`diffview-plus.lua`のようにプラグイン名に合わせます。
モジュールのテーブルは`M`として返します。
プラグイン設定は通常`lua_source()`を介してTOMLのフックと接続します。
遅延ロードを起動するキーマップは`lua/plugins/lua_add.lua`に配置してください。
Markdownの文章検査は`tools/check_md_lines.py`で行います。
無関係な整形は避けてください。

## 書き物

- 1行に情報を詰め込まない
  - 1文に話は1つにする
  - 長くなったら、文を分けるか、括弧の中身や並びを下の段に出す
  - 下の段が1つだけになるときは、箇条書きにしない
  - 基準は`tools/check_md_lines.py`にだけ持つ
  - Markdownを編集すると、Codexのhookが変更行を検査する
  - チャットの返事は検査されないので、同じ基準で自分で確かめる
  - 表のセルの中も同じ（`<br>`の1区切りを1行と数える）
- 理由・例は、その項目のすぐ下に置く
- ファイル名・行番号・実際の値・数で、具体的に書く
- 機能は番号だけで書かず、名前で書く（「機能No.4」でなく「受注情報の編集」）
- やっていないこと・まだのこと（コミットしていない など）は短く添える
- 最後に、相手に決めてほしいことを書く。質問は1つか2つに絞る
- チャットの返事・人に送る文面は、短く要点だけにする
  - 聞かれた形のまま、相手の言葉で、起きる順に答える
  - 仕様書の構成（■見出し・機能名の列挙）で書かない
  - 例外・細かい条件は、相手の判断や作業に響くものだけ書く
  - 短くするときに、省略語で詰めない

## 動作確認

Neovim設定の自動テストやカバレッジ基準はありません。
Markdown検査のテストはPython標準の`unittest`を使います。
テストファイルは`tools/test_*.py`に配置してください。

新しいNeovimセッションで対象の遅延ロード用コマンドを実行してください。
キーマップと`:messages`を確認します。
見た目の変更では、パネルの位置・サイズ・ハイライトを確認します。
カラースキーム再読み込み後の表示も確認してください。
変更の影響がある場合は、別のLSP構成やVSCode Neovimでも確認します。

## コミットとプルリクエスト

履歴に合わせて、`add: ...`、`update: ...`、`clean: ...`などの短い件名を使用します。説明文は日本語が中心です。コミットは変更の目的ごとにまとめてください。Codexが作業したコミットには`Co-authored-by: Codex <noreply@openai.com>`を付けます。

プルリクエストには、動作の変更点、実施した確認、関連Issueを記載します。UIの変更には変更前後のスクリーンショットを添えてください。

## 環境ごとの設定

環境固有の設定は、`local.example.vim`を参考にGit管理外の`local.vim`へ記載します。セッションファイル、インストール済みプラグイン、`ultisnips_local/`はコミットしないでください。
