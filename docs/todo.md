## `autoload/`, `lua/`のディレクトリ構成を変更  

### 変更案

```
// 現状
./
├── autoload/
│   ├── git_info.vim
│   ├── paste_image.vim
│   ├── plugins/
│   ├── terminal.vim
│   └── utils.vim
└── lua/
    ├── config/
    ├── const.lua
    ├── plugins/
    └── utils.lua

// 変更案
./
├── autoload/
│   ├── utils/      // あちこちから何度も呼ばれる処理
│   ├── plugins/    // プラグイン設定
└── lua/
    ├── const.lua   // 定数ファイル
    ├── config/     // 全体的な設定
    ├── plugins/    // プラグイン設定
    └── utils/      // あちこちから何度も呼ばれる処理
                    // 今のところutils.luaだけになってしまうけどlua/のルートに置くのはなんか分かりづらい気もするからいいか
```

### 変更後全体像

```
./
├── init.lua          // メインファイル
├── toml/             // プラグインの定義
├── autoload/         // vimscript
│   ├── utils/          // あちこちから何度も呼ばれる処理
│   └── plugins/        // プラグイン設定
├── lua/              // lua
│   ├── const.lua       // 定数ファイル
│   ├── config/         // 全体的な設定
│   ├── plugins/        // プラグイン設定
│   └── utils/          // あちこちから何度も呼ばれる処理
├── after/
│   └── ftplugin/       // ファイルタイプ別の設定
├── denops/           // denopsを使用した処理
│   └── gitInfo/
├── scripts/          // スクリプト類
├── ultisnips/        // 個人定義のスニペット
├── coc-settings.json // coc.nvimの設定
└── local.vim         // 環境ごとの設定(git管理外)
```
