# My Neovim Settings
自分用Neovim設定ファイル。  
まだNeovimを使い始めたばかりですが、なんとかそれなりに使える環境にはなってきたのかな...  
基本的にはMac(iTerm2)で使用。たまにWindowsのWSL(Windows Terminal)で使用。  

## ディレクトリ構成
```
nvim/
    ├── init.vim                   " メイン
    ├── autoload/
    │   ├── my_functions.vim       " 共通処理(vimscript)
    │   └── my_plugin_settings.vim " 各プラグインの設定(vimscript)
    ├── lua/
    │   ├── my_functions.lua       " 共通処理(lua)
    │   └── my_plugin_settings.lua " 各プラグインの設定(lua)
    ├── test/                      " テスト
    ├── rc/
    │   ├── my_vimrc.vim           " 基本的な設定とその他の設定の読み込み処理
    │   ├── my_clipboard.vim       " クリップボード設定(※1)
    │   ├── my_ime.vim             " IME切り替え設定(skkに乗り換えたいと思いつつまだIME...)
    │   └── my_terminal.vim        " :terminal周りの設定
    ├── toml/
    │   ├── dein.toml              " プラグイン(通常ロード)
    │   └── dein_lazy.toml         " プラグイン(遅延ロード)
    ├── coc-settings.json          " coc.nvimの設定
    ├── .editorconfig              " editorconfig
    ├── colors/
    └── pack/
        └── plugins/
            └── start/             " プラグインを作る時にここにシンボリックリンクを貼ってテストしたり
```

※1 何かのタイミングで、WSLでクリップボードが何故か極端に重くなり起動時間に影響が出たため、ファイル分割して遅延読み込みさせることにした。

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
Macだとこれの倍近くかかる。  
Linuxだから速いってことだとすると、WSLじゃなくて素のLinuxならもっと速いのかも。

- ハードウェアスペック

| | |
| ---- | ---- |
|  CPU  |  AMD Ryzen 5 3500 6-Core Processor                 3.59 GHz  |
| MEMORY | 16G |

- 高速化のために気をつけている事
  - プラグインの遅延ロード
  - 設定の遅延ロード  
  →例えばTerminalモードに関する設定を`autocmd TermOpen * ++once source 設定ファイル名`のように、使用するタイミングでロードするようにしたりなど。
  - プラグイン設定をロードするタイミングにも気を遣う  
  →(dein.nvimを使用している場合)hook_sourceやhook_post_sourceなどでなるべくロードするタイミングを遅らせる
  - 不要な標準プラグインを読み込まないように制御(場合によっては代替プラグインを探す)
  - なるべく軽いプラグインを使用する  
  →これで起動速度が倍くらい速くなったこともあるから結構大事...
  - WSLの場合、固有の事情を考慮する  
  →WSLは、Windows領域へのI/Oが遅いため、起動時には行わないようにする。  
  例えば
  ```vim
  if exepath('zenhan.exe') != ""
  ```
  のようなifは、Windows領域へファイルを探しにいくので、こういった処理は起動時ではなく後から行うようにする。

## プラグイン管理
dein.vimを使用。

## インストールが必要な外部ツール
本当はもっとある気がするけど主なものだけでもメモしておく。
- ripgrep  
→強くなったgrep的なやつ。fzfでgrepする時使う。
- bat  
→fzfのプレビューウィンドウをsyntax highlightするのに必要
- node, npm  
→coc.nvimを使用するのに必要
- [mdr](https://github.com/MichaelMure/mdr)  
→Markdownをプレビューするのに使う(preview-markdown.vim)

## session管理
ウィンドウ分割やタブを頻繁に使用するため、sessionは超使ってる。  
定期的にプロジェクトのルートで`:mksession!`してSession.vimを保存する。  
開く時は`:silent! source Session.vim(or Session.vimのシンボリックリンク)`  
sessionは多少工夫しないとよく壊れる。以下が壊れないための対策。
- sessionoptionsで、保存する内容を限定する。以下のように設定している。
```vim
set sessionoptions=buffers,curdir,tabpages
```
- NvimTreeやhelpなど、sessionが不安定になりやすいものを閉じた状態で`:mesession!`で保存する  
(helpは保存しないようにオプションで設定はしているが、念の為)

## ファイル管理
- ファイルの行き来
  - 主にfzfとNvimTreeで行き来する
    - fzf
      - ファイル名検索(プロジェクト内)
      - ファイル名検索(バッファリスト内)
      - grep  
    - NvimTree  
    主に`<C-w>t`(:NvimTreeFindFile)で現在のファイル位置にジャンプしてそこを起点にファイルを探すときくらい  
    後は普通にプロジェクトのルートからディレクトリを辿ったりとか(あんましない)
  - 定義ジャンプ(coc.nvimの機能)
  - (たまに)`:terminal`→シェル芸でファイルを探す→`gf`  
  がっつり検索したい時はシェル芸で探した方が早い
- ファイル作成、リネーム、移動等  
NvimTreeの機能を使うか、Terminalモードで。

## カッコ、クォーテーション、htmlの閉じタグ補完
[自作プラグイン](https://github.com/ukiuki-engineer/vim-autoclose)を使用。  
毎日使いながらちょっとずつチューニングしてきたためそれなりに安定しているかと...  
htmlのタグに関しては、cocのスニペットを使用することもあるが、ぶつかることなく共存可能。

## 補完、LSP
- [coc.nvim](https://github.com/neoclide/coc.nvim)
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)  
→コマンドライン補完のみnvim-cmpを使用。

## Git操作
- diffview.nvim  
vimのdiffでgit差分を見ながら、編集、変更の破棄やstageもできるので超便利。  
- vim-fugitive  
`:Git commit`とか`:Git push`とか。

## 小指の痛み対策
よく左小指を痛めるので、mouseでの操作性もなるべく上げていきたい...

## NOTE
自分用メモ
- Fonts  
[Cica](https://github.com/miiton/Cica/releases/download/v5.0.3/Cica_v5.0.3.zip)とかHackGenを使用。
- coc.nvimの拡張機能を探す場所
  - [githubのwiki](https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#implemented-coc-extensions)
  - [npm moduleを検索するサイト](https://www.npmjs.com/search?q=keywords%3Acoc.nvim)
- よく見るけど忘れがちなヘルプタグ
  - `:h key-notation`
  - `:h map-table`
  - `:h autocmd-events`

