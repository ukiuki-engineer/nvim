## 概要
自分用neovim設定ファイル。
まだneovimを使い始めたばかりなので、これから徐々に育てていく...

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
nnoremap <C-w>t :NERDTreeFind<CR>                                            " NERDTreeを開き、現在開いているファイルの場所にジャンプ(Ctrl+w t)
nnoremap <C-p> :Files<space>
nnoremap gb :Buffers<CR>
nnoremap <C-/> <Plug>(caw:i:toggle)                                          " コメントアウト(Ctrl+/)
vnoremap <C-/> <Plug>(caw:i:toggle)                                          " コメントアウト(Ctrl+/)
inoremap <expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
nnoremap <space>d <Plug>(coc-definition)                                     " 定義ジャンプ(space d)
nnoremap <space>ds :sp<CR><Plug>(coc-definition)                             " 定義ジャンプした時に水平分割(space ds)
nnoremap <space>dv :vs<CR><Plug>(coc-definition)                             " 定義ジャンプした時に垂直分割(space dv)
nnoremap <space>h :<C-u>call CocAction('doHover')<CR>                        " 関数とかのドキュメントを表示する
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
nnoremap <C-c><C-c> :nohlsearch<CR><Esc>
inoremap <C-c> <Esc>
nnoremap <TAB> :bn<Enter>                                                    " 次のバッファに切り替え(Tab)
nnoremap <S-TAB> :bN<Enter>                                                  " 前のバッファに切り替え(Shift+Tab)
tnoremap <Esc> <C-\><C-n>                                                    " ターミナルモード(:termimal)からノーマルモードにに入る(ESC)
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

## Fonts
[Cica](https://github.com/miiton/Cica/releases/download/v5.0.3/Cica_v5.0.3.zip)を使用。

## FIXME
- lspの一部のエラー表示が出ないように設定で変更できないか  
例えば以下のような場合
  - laravelで```use DB```としても、DBを使ってる箇所で```undefined```と表示される  
  →多分、DBをフルパスで書かないと怒られるようになってる
  - markdwonで、```#```を使わずに```##```から始めると警告が出る  
  →```#```はでかくなりすぎて自分はあまり好きじゃないから使わない...
  - コメントの中はundefinedをcheckしない
