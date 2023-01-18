## 概要
自分用neovim設定ファイル。  
まだneovimを使い始めたばかりなので移行は大変でしたが、ある程度は整ってきたかなと思います。  
基本的にはMac、たまにWindowsのWSLで使用。

## ディレクトリ構成

```
├── init.vim          " メインの設定ファイル
├── plugins.vim       " プラグイン関係
├── toml              " プラグイン関係
│   ├── dein.toml
│   └── dein_lazy.toml
├── coc-settings.json " cocの設定
├── colors
│   └── tender.vim
└── pack
    └── plugins
        └── start     " プラグインを作る時にここにシンボリックリンクを貼ってテストしたり
```

## キーマップ
各ファイルで定義しているので、ここにメモとしてまとめておく。
```vim
nnoremap <C-n> :NERDTreeToggle<CR>                                           " NERDTreeを開く
nnoremap <C-w>t :NERDTreeFind<CR>                                            " NERDTreeを開き、現在開いているファイルの場所にジャンプ
nnoremap <C-p> :Files<CR>
nnoremap gb :Buffers<CR>
nnoremap <C-/> <Plug>(caw:i:toggle)                                          " コメントアウト
vnoremap <C-/> <Plug>(caw:i:toggle)                                          " コメントアウト
inoremap <expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
nnoremap <space>d <Plug>(coc-definition)                                     " 定義ジャンプ
nnoremap <space>ds :sp<CR><Plug>(coc-definition)                             " 定義ジャンプした時に水平分割
nnoremap <space>dv :vs<CR><Plug>(coc-definition)                             " 定義ジャンプした時に垂直分割
nnoremap <space>h :<C-u>call CocAction('doHover')<CR>                        " 関数とかのドキュメントを表示する
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
nnoremap <C-c><C-c> :nohlsearch<CR><Esc>
inoremap <C-c> <Esc>
nnoremap <TAB> :bn<Enter>                                                    " 次のバッファに切り替え
nnoremap <S-TAB> :bN<Enter>                                                  " 前のバッファに切り替え
tnoremap <Esc> <C-\><C-n>                                                    " ターミナルモード(:termimal)から```ESC```でノーマルモードにに入る
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
    " fzfの操作
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

## カッコ、クォーテーション、htmlの閉じタグ補完
[自作プラグイン](https://github.com/ukiuki-engineer/vim-autoclose)を使用。

## memo
- Fonts  
[Cica](https://github.com/miiton/Cica/releases/download/v5.0.3/Cica_v5.0.3.zip)を使用。
- coc.nvimの拡張機能を探す場所
  - [githubのwiki](https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#implemented-coc-extensions)
  - [npm moduleを検索するサイト](https://www.npmjs.com/search?q=keywords%3Acoc.nvim)

## FIXME
- lspの一部のエラー表示が出ないように設定で変更できないか  
例えば以下のような場合
  - laravelで```use DB```としても、DBを使ってる箇所で```undefined```と表示される  
  →多分、DBをフルパスで書かないと怒られるようになってる
  - markdwonで、```#```を使わずに```##```から始めると警告が出る  
  →```#```はでかくなりすぎて自分はあまり好きじゃないから使わない...
  - コメントの中はundefinedをcheckしない
- 補完のポップアップウィンドウの配色設定をいい感じに変更したい  
どれが選択されてるやつなのか見づらい
