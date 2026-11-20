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

ビルドは不要です。事前にNeovim、Git、Deno、Node.js、ripgrepをインストールしてください。

- `nvim`：このリポジトリを`~/.config/nvim`に配置して起動します。未導入のプラグインは起動時にインストールされます。
- `LSP_PLUGIN_SELECTION=2 nvim`：Mason/LSPConfigを選択します。既定値はcoc.nvimを使う`1`です。
- `:call dein#recache_runtimepath()`：プラグイン定義やLSPの選択を変更した後に、deinのキャッシュを更新します。
- `deno check denops/gitInfo/main.ts`：Denopsの起点ファイルを型チェックします。リモート依存の初回取得にはネットワーク接続が必要です。
- `git diff --check`：提出前に空白の不備を確認します。

## コーディングスタイルと命名

`.editorconfig`に従い、UTF-8、LF改行、スペース2文字のインデント、ファイル末尾の改行を使用します。Markdownでは行末の空白を許可しています。

周囲のLua・Vimscriptの書き方に合わせてください。Luaの関数名は`snake_case`、ファイル名は`diffview-plus.lua`のようにプラグイン名に合わせ、モジュールのテーブルは`M`として返します。プラグイン設定は通常`lua_source()`を介してTOMLのフックと接続します。遅延ロードを起動するキーマップは`lua/plugins/lua_add.lua`に配置してください。リポジトリ全体のフォーマッター・リンター設定はないため、無関係な整形は避けます。

## 動作確認

自動テストのフレームワーク、テスト名の規約、カバレッジ基準はありません。新しいNeovimセッションで対象の遅延ロード用コマンドを実行し、キーマップと`:messages`を確認してください。見た目を変更した場合は、パネルの位置・サイズ・ハイライトと、カラースキーム再読み込み後の表示を確認します。変更の影響がある場合は、別のLSP構成やVSCode Neovimでも確認してください。

## コミットとプルリクエスト

履歴に合わせて、`add: ...`、`update: ...`、`clean: ...`などの短い件名を使用します。説明文は日本語が中心です。コミットは変更の目的ごとにまとめてください。Codexが作業したコミットには`Co-authored-by: Codex <noreply@openai.com>`を付けます。

プルリクエストには、動作の変更点、実施した確認、関連Issueを記載します。UIの変更には変更前後のスクリーンショットを添えてください。

## 環境ごとの設定

環境固有の設定は、`local.example.vim`を参考にGit管理外の`local.vim`へ記載します。セッションファイル、インストール済みプラグイン、`ultisnips_local/`はコミットしないでください。
