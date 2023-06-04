" ================================================================================
" init.vim
" ================================================================================
" if &compatible
"   " NOTE: Neovimだといらないらしい
"   set nocompatible
" endif

let s:cache         = expand('$HOME/.cache')
let s:dein_dir      = expand(s:cache .. '/dein')
let s:dein_repo_dir = s:dein_dir .. '/repos/github.com/Shougo/dein.vim'
let g:init_dir      = expand('$HOME/.config/nvim')
let g:rc_dir        = g:init_dir .. '/rc'
let s:toml          = g:init_dir .. '/toml/dein.toml'
let s:lazy_toml     = g:init_dir .. '/toml/dein_lazy.toml'

" ~/.cacheが無ければ作成
if !isdirectory(s:cache)
  call mkdir(s:cache, 'p')
endif

" deinが無ければインストール
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' .. fnamemodify(s:dein_repo_dir, ':p')
endif

" dein options
let g:dein#auto_recache = v:true
" 一応loading rtp pluginsに結構時間かかってるっぽいからtrueにしてみる
let g:dein#lazy_rplugins = v:true
" とりあえずhelpの値を入れてみる...
let g:dein#install_check_remote_threshold = 24 * 60 * 60

" 設定開始
if dein#load_state(s:dein_dir)
  " vimrc
  let g:dein#inline_vimrcs = [g:rc_dir .. '/my_vimrc.vim']

  call dein#begin(s:dein_dir)

  " tomlのロード
  call dein#load_toml(s:toml,      {'lazy':0})
  call dein#load_toml(s:lazy_toml, {'lazy':1})

  call dein#end()
  call dein#save_state()
endif

" 未インストールがあればインストール
if dein#check_install()
  call dein#install()
endif

" ファイル形式別プラグインの有効化
filetype plugin indent on
" シンタックスハイライトの有効化
syntax enable

