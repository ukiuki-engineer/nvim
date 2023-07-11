# My Neovim Settings
基本的にはMac(iTerm2)で使用。たまにWindowsのWSL(Windows Terminal)で使用。  
![image](https://github.com/ukiuki-engineer/nvim/assets/101523180/2bce9011-06d4-499c-9a19-bc38f7ff8c23)

## 起動速度
- WSL2で測定した結果
```
vim-startuptime -vimpath nvim
Extra options: []
Measured: 10 times

Total Average: 25.044000 msec
Total Max:     25.874000 msec
Total Min:     23.898000 msec
```

- ハードウェアスペック

| | |
| ---- | ---- |
|  CPU  |  AMD Ryzen 5 3500 6-Core Processor                 3.59 GHz  |
| MEMORY | 16G |

## ディレクトリ構成
```
nvim/
    ├── init.vim                   " メインファイル
    ├── autoload/
    │   ├── utils.vim              " 共通処理(vimscript)
    │   └── plugins/               " 各プラグインの設定(vimscript)
    │       ├── ui.vim
    │       ├── code_editting.vim
    │       ├── lsp_and_completion.vim
    │       ├── git.vim
    │       └── others.vim
    ├── lua/
    │   ├── utils.lua              " 共通処理(lua)
    │   └── plugins/               " 各プラグインの設定(lua)
    │       ├── ui.lua
    │       ├── code_editting.lua
    │       ├── lsp_and_completion.lua
    │       ├── git.lua
    │       └── others.lua
    ├── rc/
    │   ├── my_vimrc.vim           " 基本的な設定とその他の設定の読み込み処理
    │   ├── my_clipboard.vim
    │   ├── my_ime.vim
    │   ├── my_terminal.vim
    │   └── paste_image.vim
    ├── toml/
    │   ├── dein.toml              " プラグイン(通常ロード)
    │   └── dein_lazy.toml         " プラグイン(遅延ロード)
    ├── tools/                     " 色々なスクリプト類など
    ├── coc-settings.json          " coc.nvimの設定
    └── .editorconfig              " editorconfig
```

## NOTE
自分用メモ
- Fonts  
[Cica](https://github.com/miiton/Cica/releases/download/v5.0.3/Cica_v5.0.3.zip)とかHackGenを使用。  
iconを設定するときなどは[ここ](https://www.nerdfonts.com/cheat-sheet)見たりとか。
- coc.nvimの拡張機能を探す場所
  - [githubのwiki](https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#implemented-coc-extensions)
  - [npm moduleを検索するサイト](https://www.npmjs.com/search?q=keywords%3Acoc.nvim)
- 時々見たいけど忘れがちなヘルプタグ
  - `:h key-notation`
  - `:h map-table`
  - `:h autocmd-events`
  - `:h encoding-values`
