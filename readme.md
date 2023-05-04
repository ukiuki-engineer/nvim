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
    │   └── my_plugin_settings.vim " 各プラグインの設定はほぼ全部ここに(※1)
    ├── lua/
    │   └── my_functions.lua       " 共通処理(lua)
    ├── test/                      " テスト
    ├── rc/
    │   ├── my_vimrc.vim           " 基本的な設定とその他の設定の読み込み処理
    │   ├── my_clipboard.vim       " クリップボード設定(※2)
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
※1: このファイルに、各プラグインの設定を関数として全て突っ込んでいる。(my_plugin_settings#hook_source_treesitter()など)  
これらを、tomlから`call`で呼んでいる。
この構成だと、最初に設定が呼ばれたタイミングでこのファイル自体が全部読まれてしまう。(つまり起動時にこのファイル全体が読まれる)  
速度を気にするなら、設定ごとにファイル分割するか、全部tomlに突っ込むべきかもしれない。  
しかし、以下の理由でこのままの構成としている。
- (当たり前だけど)読まれた時にファイルの内容が全部実行されるわけではなく、各処理を呼んだ時に実行されるため、読み込み自体にはそこまで時間はかかっていない。(0.2ms程度)
- プラグイン設定は全部1箇所に集めておいた方が個人的には見通しが良いと感じる。

※2: 何かのタイミングで、WSLでクリップボードが何故か極端に重くなり起動時間に影響が出たため、ファイル分割して遅延読み込みさせることにした。

## 起動速度
自分の環境ではこんな感じ。
```
vim-startuptime -vimpath nvim
Extra options: []
Measured: 10 times

Total Average: 44.718100 msec
Total Max:     47.700000 msec
Total Min:     42.350000 msec
```
めっちゃ速いわけではないけどまー遅くはないはず...  
高速化のために気をつけているのは以下の点。

- プラグインの遅延ロード
- 設定の遅延ロード(プラグイン設定に限らず)
- 不要な標準プラグインを読み込まないように制御(場合によっては代替プラグインを探す)
- なるべく軽いプラグインを使用する

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

## キーマップ
なるべくシンプルにしたいので、プラグインを呼び出すためのマッピングが主です。

## コマンド定義
よく使うけど若干面倒な操作は随時コマンド化したりとか。  

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

