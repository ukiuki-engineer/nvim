## 概要
自分用neovim設定ファイル。  
まだneovimを使い始めたばかりなので移行は大変でしたが、ある程度整ってきたかな。  
なるべくシンプルに使えるような設定を目指している。  
基本的にはMac(iTerm2)で使用、たまにWindowsのWSL(Windows Terminal)で使用。  
(そろそろlua化したい...)

## ディレクトリ構成
割とオーソドックスだと思う、多分...
```
nvim/
    ├── init.vim          " メインの設定ファイル
    ├── plugins.vim       " プラグイン関係
    ├── toml/             " プラグイン関係
    │   ├── dein.toml
    │   └── dein_lazy.toml
    ├── coc-settings.json " coc.nvimの設定
    ├── colors/
    └── pack/
        └── plugins/
            └── start/    " プラグインを作る時にここにシンボリックリンクを貼ってテストしたり
```

## キーマップ
各ファイルで定義しているので、ここにメモとしてまとめておく。  
基本方針は"**vim本来の操作性を崩さないように**"すること。  
そのためプラグインを呼び出すためのマッピングが主で、vimそのもののキーマップは**なるべく**変更しないようにする。  
どうしてもの場合は仕方ない。
```vim
nnoremap <C-n>        :NERDTreeToggle<CR>                                  " NERDTree表示/非表示切り替え
nnoremap <C-w>t       :NERDTreeFind<CR>                                    " NERDTreeを開き、現在開いているファイルの場所にジャンプ
nnoremap <C-p>        :Files<CR>                                           " ファイル名検索(カレントディレクトリ配下)
nnoremap gb           :Buffers<CR>                                         " ファイル名検索(バッファリスト)
nnoremap <C-/>        <Plug>(caw:hatpos:toggle)                            " コメントアウト(ノーマルモード)
vnoremap <C-/>        <Plug>(caw:hatpos:toggle)                            " コメントアウト(ビジュアルモード)
inoremap <expr> <CR>  coc#pum#visible() ? coc#pum#confirm() : "\<CR>"      " 補完の選択をEnterで決定
nnoremap <space>d     <Plug>(coc-definition)                               " 定義ジャンプ(※)
nnoremap <space>h     :<C-u>call CocAction('doHover')<CR>                  " 関数とかの情報を表示する
nnoremap <Esc><Esc>   :nohlsearch<CR><Esc>                                 " Esc2回で検索結果のハイライトをオフに(多分割とよく使われてる設定)
inoremap <C-c>        <Esc>
nnoremap <TAB>        :bn<Enter>                                           " 次のバッファに切り替え
nnoremap <S-TAB>      :bN<Enter>                                           " 前のバッファに切り替え
tnoremap <Esc>        <C-\><C-n>                                           " ターミナルモード(:termimal)から```ESC```でノーマルモードにに入る
```
※定義元を画面分割して表示したい場合は、画面分割後ジャンプする  
　最初はキーマップを定義していたが結局この手順に落ち着いている

<a id="user-command"></a>
## 独自定義コマンド
よく使うけど若干面倒な操作は随時コマンド化する(かも)
- ```:T```  
ウィンドウを分割してターミナルを開く。
- ```:TermHere```  
カレントバッファのディレクトリ&ウィンドウを分割してターミナルを開く(ただ:lcd %:hの後に:Tしてるだけ)  
いちいちディレクトリ移動してからターミナル開くのが面倒だったため定義した。  
カレントバッファのディレクトリでファイル操作したい時などに割と便利。
- ```:Format```  
coc.nvimのフォーマッター(CocAction('format'))を呼ぶ。

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

## session管理
sessionが壊れないための対策
- sessionoptionsで、保存する内容を限定する。以下のように設定している。
```vim
set sessionoptions=buffers,curdir,tabpages
```
- NERDTreeやhelpなど、sessionが不安定になりやすいものを閉じた状態で```:mesession!```で保存する

## ファイル管理
- ファイルの行き来
  - 主にfzfとNERDTreeで行き来する
    - fzf
    ```vim
    " 基本的なfzfの操作
    :Files    " ファイル名検索(キーマップ→<C-p>)
    :Buffers  " バッファからファイル名で検索(キーマップ→gb)
    :Rg       " Grep
    ```
    - NERDTree
    主に```<C-w>t```(:NERDTreeFind)で現在のファイル位置にジャンプしてそこを起点にファイルを探すときくらい  
    後は普通にプロジェクトのルートからディレクトリを辿ったりとか
  - 定義ジャンプ→```<space>d```
- ファイル作成、リネーム、移動等  
NERDTreeの機能を使うより```:terminal```で操作した方が楽...  
大体は[```:TermHere```](#user-command)でカレントバッファのディレクトリでterminalを開き、そこで操作することが多い。これで結構素早く操作できる。

## カッコ、クォーテーション、htmlの閉じタグ補完
[自作プラグイン](https://github.com/ukiuki-engineer/vim-autoclose)を使用。  
毎日使いながらちょっとずつチューニングしてきたためそれなりに安定しているかと...  
htmlのタグに関しては、cocのスニペットを使用することもあるが、ぶつかることなく共存可能。

## NOTE
- Fonts  
[Cica](https://github.com/miiton/Cica/releases/download/v5.0.3/Cica_v5.0.3.zip)を使用。
- coc.nvimの拡張機能を探す場所
  - [githubのwiki](https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#implemented-coc-extensions)
  - [npm moduleを検索するサイト](https://www.npmjs.com/search?q=keywords%3Acoc.nvim)
