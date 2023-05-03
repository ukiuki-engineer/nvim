" ================================================================================
" MyVimrc.vim
" ================================================================================
" ------------------------------------------------------------------------------
" options
" ------------------------------------------------------------------------------
" 文字コード
set enc=utf-8
set fileencodings=utf-8,sjis,iso-2022-jp,euc-jp
" ヘルプを日本語化
set helplang=ja
" マウス有効化
set mouse=a
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" カーソル行、列を表示
set cursorline cursorcolumn
" ルーラーを表示しない
set noruler
" 行番号を表示
set number
" タブや改行を表示
set list
" タブや改行の表示記号を定義
" set listchars=tab:»-,trail:-,eol:↓,extends:»,precedes:«,nbsp:%
" 画面を垂直分割する際に右に開く
set splitright
" 画面を水平分割する際に下に開く
set splitbelow
" 検索時にファイルの最後まで行っても最初に戻らない
set nowrapscan
" 検索時に大文字小文字を無視
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase
" sessionに保存する内容を指定
set sessionoptions=buffers,curdir,tabpages
" Tab文字を半角スペースにする
set expandtab
" インデントは基本的に2
set shiftwidth=2 tabstop=2 softtabstop=2
" ------------------------------------------------------------------------------
" autocmd
" ------------------------------------------------------------------------------
augroup MyVimrc
  autocmd!
  " Laravelが4なのでphpは4に
  autocmd FileType php setlocal tabstop=4 shiftwidth=4 softtabstop=4
  " .env系はシェルスクリプトとして開く
  autocmd BufRead .env,.env.* setlocal filetype=sh
  " NOTE: なぜか急にerubyが異常に重くなったのでとりあえずrubyとして開くことに...
  autocmd BufRead *.erb setlocal filetype=ruby
  " CursorHold時のみカーソル行/列を表示
  " autocmd CursorHold * call my_functions#set_cursor_line_column()
  " IME切り替え設定の読み込み
  autocmd InsertEnter,CmdlineEnter * ++once execute 'source' . g:rc_dir . '/my_ime.vim'
  " クリップボード設定の遅延読み込み(急にWSLで重くなったので遅延させる)
  autocmd InsertEnter,CursorMoved * ++once execute 'source' . g:rc_dir . '/my_clipboard.vim'
  " NOTE: toggletermと一緒にdein側で制御する
  " :terminal設定の読み込み1
  " autocmd TermOpen * ++once execute 'source' . g:rc_dir . '/MyTerminal.vim'
  " :terminal設定の読み込み2
  " autocmd CmdUndefined Term,TermV,TermHere,TermHereV ++once execute 'source' . g:rc_dir . '/MyTerminal.vim'
augroup END
" ------------------------------------------------------------------------------
" maps
" ------------------------------------------------------------------------------
nnoremap <Esc><Esc> :nohlsearch<CR>
nnoremap <TAB> :bn<CR>
nnoremap <S-TAB> :bN<CR>
" ------------------------------------------------------------------------------
" commands
" ------------------------------------------------------------------------------
" NOTE: 以下は、コマンド定義するより、補完されるようにした方が良いかも？
command! SetCursorLineColumn :set cursorline cursorcolumn
command! SetNoCursorLineColumn :set nocursorline nocursorcolumn
command! SourceSession :silent! source Session.vim
" ------------------------------------------------------------------------------
" 標準プラグインの制御
" ------------------------------------------------------------------------------
let g:did_indent_on             = 1
let g:did_install_default_menus = 1
let g:did_install_syntax_menu   = 1
let g:did_load_ftplugin         = 1
let g:loaded_gzip               = 1
let g:loaded_man                = 1
let g:loaded_matchit            = 1
let g:loaded_matchparen         = 1
let g:loaded_netrwPlugin        = 1
let g:loaded_remote_plugins     = 1
let g:loaded_shada_plugin       = 1
let g:loaded_spellfile_plugin   = 1
let g:loaded_tarPlugin          = 1
let g:loaded_tarPlugin          = 1
let g:loaded_tutor_mode_plugin  = 1
let g:loaded_zipPlugin          = 1
let g:skip_loading_mswin        = 1
" 標準プラグインの遅延読み込み
" call my_functions#lazy_load()
