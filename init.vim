" ================================================================================
" init.vim
" ================================================================================
"
if &modifiable == 1
  set enc=utf-8
  set fenc=utf-8
endif
set cursorline
set cursorcolumn
" 行番号を表示
set number
" タブや改行を表示
set list
set listchars=tab:»-,trail:-,eol:↓,extends:»,precedes:«,nbsp:%
" Tab 文字を半角スペースにする
set expandtab
" 行頭での Tab 文字の表示幅
set shiftwidth=2
" ファイルタイプ毎のインデント設定
augroup fileTypeIndent
  autocmd!
  autocmd FileType php setlocal tabstop=4 shiftwidth=4 softtabstop=4
augroup END
set clipboard+=unnamed
" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set nowrapscan
" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase
" キーマッピング
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
nnoremap <C-c><C-c> :nohlsearch<CR><Esc>
inoremap <C-c> <Esc>
nnoremap <TAB> :bn<Enter>
nnoremap <S-TAB> :bN<Enter>
" ------------------------------------------------------------------------------
"
" IME切り替え設定
"
" FIXME: 切り替えが遅い
" FIXME: <C-c>で抜けた時に発火しない
if has('mac') && !has("gui_macvim")
  augroup im_select
    autocmd!
    autocmd InsertLeave * :call system('im-select com.apple.keylayout.ABC')
    autocmd InsertEnter * :call system('im-select com.apple.keylayout.ABC')
    autocmd BufRead * :call system('im-select com.apple.keylayout.ABC')
    autocmd CmdlineLeave * :call system('im-select com.apple.keylayout.ABC')
    autocmd CmdlineEnter * :call system('im-select com.apple.keylayout.ABC')
  augroup END
endif
" ------------------------------------------------------------------------------
"
" dein
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
let s:dein_base = '~/.cache/dein/'
let s:dein_src = '~/.cache/dein/repos/github.com/Shougo/dein.vim'
execute 'set runtimepath+=' . s:dein_src
call dein#begin(s:dein_base)
  " プラグインリスト(toml)
  let g:rc_dir    = expand('$HOME/.config/nvim')
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
" ------------------------------------------------------------------------------
" tomlに書けなかった各プラグインの設定をここに書く
" 
if isdirectory($HOME . "/.cache/dein/repos/github.com/jacoborus/tender.vim")
  if (has("termguicolors"))
    set termguicolors
  endif
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  syntax enable
  silent! colorscheme tender
  let g:lightline = { 'colorscheme': 'tender' }
  let g:airline_theme = 'tender'
  let macvim_skip_colorscheme=1
endif

