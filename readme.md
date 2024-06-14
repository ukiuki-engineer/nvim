# My Neovim Settings

基本的には Mac(iTerm2)で使用。たまに Windows の WSL(Windows Terminal)で使用。
![image](https://github.com/ukiuki-engineer/nvim/assets/101523180/3aebf65a-4200-43fb-a921-b2eac3eb585c)

# 起動速度

- WSL2 で測定した結果

```
vim-startuptime -vimpath nvim
Extra options: []
Measured: 10 times

Total Average: 11.435600 msec
Total Max:     11.843000 msec
Total Min:     11.237000 msec
```

→[log](https://github.com/ukiuki-engineer/nvim/blob/master/vim-startuptime.log)

- ハードウェアスペック

|        |                                            |
| ------ | ------------------------------------------ |
| CPU    | AMD Ryzen 5 3500 6-Core Processor 3.59 GHz |
| MEMORY | 16G                                        |

# Required

事前に下記をインストールしておく。

- [Deno](https://deno.com/)
- Node

# ディレクトリ構造

```
nvim/
├── init.lua          // メインファイル
├── toml/             // プラグインの定義
├── autoload/         // vimscript
│   ├── utils/          // あちこちから何度も呼ばれる処理
│   └── plugins/        // プラグイン設定
├── lua/              // lua
│   ├── const.lua       // 定数ファイル
│   ├── config/         // 全体的な設定
│   ├── plugins/        // プラグイン設定
│   └── utils/          // あちこちから何度も呼ばれる処理
├── after/
│   └── ftplugin/       // ファイルタイプ別の設定
├── denops/           // denopsを使用した処理
│   └── gitInfo/
├── scripts/          // スクリプト類
├── ultisnips/        // 個人定義のスニペット
├── coc-settings.json // coc.nvimの設定
└── local.vim         // 環境ごとの設定(git管理外)
```


# 仕事集中モード

仕事に集中したいときは、この`nvim/`直下に`working`というファイルを配置する。  
→Neovim設定を開いても強制的に閉じるようになっている。

