# My Neovim Settings
自分用Neovim設定ファイル。  
まだNeovimを使い始めたばかりですが、なんとかそれなりに使える環境にはなってきたのかな...  
もっと色々工夫して良い環境にできたらと。  
なるべくシンプルに使えるような設定を目指している。  
基本的にはMac(iTerm2)で使用。たまにWindowsのWSL(Windows Terminal)で使用。  

## ディレクトリ構成
```
nvim/
    ├── init.vim                 " メイン
    ├── autoload/
    │   ├── MyFunctions.vim      " 共通処理(vimscript)
    │   └── MyPluginSettings.vim " 各プラグインの設定
    ├── lua/
    │   └── my_functions.lua     " 共通処理(lua)
    ├── test/                    " テスト
    ├── rc/
    │   ├── MyVimrc.vim          " 基本的な設定とその他の設定の読み込み処理
    │   ├── MyIME.vim            " IME切り替え設定
    │   └── MyTerminal.vim       " :terminal周りの設定
    ├── toml/
    │   ├── dein.toml            " プラグイン(通常ロード)
    │   └── dein_lazy.toml       " プラグイン(遅延ロード)
    ├── coc-settings.json        " coc.nvimの設定
    ├── .editorconfig            " editorconfig
    ├── colors/
    └── pack/
        └── plugins/
            └── start/           " プラグインを作る時にここにシンボリックリンクを貼ってテストしたり
```

## プラグイン管理
dein.vimを使用。

## インストールが必要な外部ツール
本当はもっとある気がするけど主なものだけでもメモしておく。
- ripgrep  
→fzfのRgを使用するのに必要
- bat  
→fzfのプレビューウィンドウをsyntax highlightするのに必要
- node, npm  
→coc.nvimを使用するのに必要
- [mdr](https://github.com/MichaelMure/mdr)  
→Markdownをプレビューするのに使う(preview-markdown.vim)

## キーマップ
基本方針は"**vim本来の操作性を崩さないように**"すること。  
そのためプラグインを呼び出すためのマッピングが主で、vimそのもののキーマップは**なるべく**変更しないようにする。  
どうしてもの場合は仕方ない。

## コマンド定義
よく使うけど若干面倒な操作は随時コマンド化する。  


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
    ```vim
    " 基本的なfzfの操作
    :Files    " ファイル名検索(キーマップ→<C-p>)
    :Buffers  " バッファからファイル名で検索(キーマップ→gb)
    :Rg       " Grep
    ```
    - NvimTree  
    主に`<C-w>t`(:NvimTreeFindFile)で現在のファイル位置にジャンプしてそこを起点にファイルを探すときくらい  
    後は普通にプロジェクトのルートからディレクトリを辿ったりとか
  - 定義ジャンプ→`<space>d`
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
→コマンドライン補完のみnvim-cmpを使用。(※試運転中。cocとぶつからないかが心配。多分大丈夫。)

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

## TODO
- ファイル名をスネークケースに統一した方がいいかも
