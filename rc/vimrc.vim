" ================================================================================
" vimrc.vim
" ================================================================================
" ------------------------------------------------------------------------------
" options
" ------------------------------------------------------------------------------
" 文字コード{{{
" NOTE: `:h encoding-values`
" Vim が内部処理に利用する文字コード。保存時に使用する文字コード
set encoding=utf-8
" Vim が 既存ファイルの 文字コード推定に使う文字コードのリスト。
set fileencodings=utf-8,sjis,iso-2022-jp,euc-jp
"  新規ファイルを作成する際の文字コード
set fileencoding=utf-8
" }}}
" スワップファイルを作らない
set noswapfile
" マウス有効化
set mouse=a
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" カーソル行、列を表示
set cursorline cursorcolumn
" ルーラーを表示しない、行番号を表示、タブや改行を表示
set noruler number list
" タブや改行の表示記号を定義
" set listchars=tab:»-,trail:-,eol:↓,extends:»,precedes:«,nbsp:%
" 画面を垂直(水平)分割する際に右(下)に開く
set splitright splitbelow
" 検索時の挙動
set nowrapscan ignorecase smartcase
" sessionに保存する内容を指定
set sessionoptions=buffers,curdir,tabpages
" Tab文字を半角スペースにする
set expandtab
" インデントは基本的に2
set shiftwidth=2 tabstop=2 softtabstop=2
" 符号なし数字として扱う
set nrformats+=unsigned
" ------------------------------------------------------------------------------
" autocmd
" ------------------------------------------------------------------------------
augroup MyVimrc
  autocmd!
  " Laravelが4なのでphpは4に
  autocmd FileType php setlocal tabstop=4 shiftwidth=4 softtabstop=4
  " FIXME: markdownだけ何故かインデン4になってしまうので一旦強制的に2に。後で原因を調べる。
  autocmd FileType markdown setlocal tabstop=2 shiftwidth=2 softtabstop=2
  " .env系はシェルスクリプトとして開く
  autocmd BufRead .env,.env.* setlocal filetype=sh
  " CursorHold時のみカーソル行/列を表示
  " autocmd CursorHold * call utils#set_cursor_line_column()
  " 遅延ロード {{{
  " command定義
  autocmd CmdlineEnter * ++once execute 'source ' .. g:rc_dir .. '/commands.vim'
  " :terminal設定の読み込み1
  autocmd TermOpen * ++once execute 'source ' .. g:rc_dir .. '/terminal.vim'
  " :terminal設定の読み込み2
  autocmd CmdUndefined Terminal,Term,TermV,TermHere,TermHereV ++once execute 'source ' .. g:rc_dir .. '/terminal.vim'
  " IME切り替え設定の読み込み(WSLの場合Windows領域へのI/Oが遅く、それが起動時間に影響するため遅延ロードする)
  autocmd InsertEnter,CmdlineEnter * ++once execute 'source ' .. g:rc_dir .. '/ime.vim'
  " クリップボード設定の遅延読み込み(WSLの場合Windows領域へのI/Oが遅く、それが起動時間に影響するため遅延ロードする)
  autocmd InsertEnter,CursorMoved * ++once execute 'source ' .. g:rc_dir .. '/clipboard.vim'
  " markdownで、画像をクリップボードから貼り付けする設定の読み込み
  autocmd CmdUndefined PasteImage ++once execute 'source ' .. g:rc_dir .. '/paste_image.vim'
  " }}}
augroup END
" ------------------------------------------------------------------------------
" Key mapping
" ------------------------------------------------------------------------------
execute 'source ' .. g:rc_dir .. '/mapping.vim'
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
let g:loaded_netrw              = 1
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
" call utils#lazy_load()
" ------------------------------------------------------------------------------
" FIXME: 応急処置。いつか消す。
" 最近macの時だけvimが落ちるようになったので、応急処置として保存時にmksessionする
" ------------------------------------------------------------------------------
if has('mac')
  let g:pwd_in_startup = $PWD
  augroup PwdInStartup
    autocmd!
    autocmd BufWrite * execute 'mksession! ' .. expand(g:pwd_in_startup) .. '/Session.vim'
  augroup END
endif
