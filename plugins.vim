" ------------------------------------------------------------------------------
"
" deinインストール---ここから
let $CACHE = expand('~/.cache')
if !isdirectory($CACHE)
  call mkdir($CACHE, 'p')
endif
if &runtimepath !~# '/dein.vim'
  let s:dein_dir = fnamemodify('dein.vim', ':p')
  if !isdirectory(s:dein_dir)
    let s:dein_dir = $CACHE . '/dein/repos/github.com/Shougo/dein.vim'
    if !isdirectory(s:dein_dir)
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
    endif
  endif
  execute 'set runtimepath^=' . substitute(
        \ fnamemodify(s:dein_dir, ':p') , '[/\\]$', '', '')
endif
" deinインストール---ここまで

" dein設定---ここから
set nocompatible
let g:rc_dir = expand('~/.config/nvim')
let s:dein_base = '~/.cache/dein/'
let s:dein_src = '~/.cache/dein/repos/github.com/Shougo/dein.vim'
execute 'set runtimepath+=' . s:dein_src
call dein#begin(s:dein_base)
  " プラグインリスト(toml)
  let s:toml      = g:rc_dir . '/toml/dein.toml'
  let s:lazy_toml = g:rc_dir . '/toml/dein_lazy.toml'
  " tomlのロード
  call dein#load_toml(s:toml,      {'lazy':0})
  call dein#load_toml(s:lazy_toml, {'lazy':1})
call dein#end()

if has('filetype')
  filetype indent plugin on
endif

if has('syntax')
  syntax on
endif

if dein#check_install()
  call dein#install()
endif
" dein設定---ここまで
