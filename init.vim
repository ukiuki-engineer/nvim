" ================================================================================
" init.vim
" ================================================================================
" NOTE: オプション(set xxxとできるもの)をifとかで使いたい場合は&xxxとすれば良い(:h &)
" ------------------------------------------------------------------------------
" 基本的な設定
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
" NOTE: 以下二つは重いので入れるか結構迷う。入れたり入れなかったりブレブレ。
set cursorline cursorcolumn
set noruler
" NOTE: relativenumberは便利だけど重くなるからいつも悩む
" 行番号
set number norelativenumber
" タブや改行を表示
set list
" タブや改行の表示記号を定義
" set listchars=tab:»-,trail:-,eol:↓,extends:»,precedes:«,nbsp:%
" ヤンクした文字列をクリップボードにコピー
set clipboard+=unnamed
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
"Tab文字を半角スペースにする
set expandtab
" インデントは基本的に2
set shiftwidth=2 tabstop=2 softtabstop=2
" ------------------------------------------------------------------------------
" autocmd
" ------------------------------------------------------------------------------
" ファイルタイプ、拡張子毎のインデント設定
augroup MyFileTypeIndent
  autocmd!
  " Laravelが4なのでphpは4に
  autocmd FileType php setlocal tabstop=4 shiftwidth=4 softtabstop=4
  autocmd BufEnter .env,.env.example setlocal filetype=sh
augroup END
" IME切り替え設定
augroup MyIME
  autocmd!
  if has('mac') && exepath('im-select') != ""
    " NOTE: macの場合im-selectをインストールしてPATHを通しておく
    autocmd InsertLeave,InsertEnter,BufRead,CmdlineLeave,CmdlineEnter * :call system('im-select com.apple.keylayout.ABC')
  endif
  if !has('mac') && exepath('zenhan.exe') != ""
    " NOTE: windows(WSL)の場合、zenhanをインストールしてPATHを通しておく
    autocmd InsertLeave,InsertEnter,BufRead,CmdlineLeave,CmdlineEnter * :call system('zenhan.exe 0')
  endif
augroup END
" ------------------------------------------------------------------------------
" キーマッピング
" ------------------------------------------------------------------------------
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
inoremap <C-c>      <Esc>
nnoremap <TAB>      :bn<Enter>
nnoremap <S-TAB>    :bN<Enter>
" ------------------------------------------------------------------------------
" :terminal設定の読み込み
" ------------------------------------------------------------------------------
augroup LoadMyTerminalSettings
  autocmd!
  autocmd TermOpen * ++once source ~/.config/nvim/rc/MyTerminal.vim
  " FIXME: MyTerminal.vim読み込まないと以下のコマンド補完が効かないのを、なんとかしたい
  autocmd CmdUndefined Term,TermV,TermHere,TermHereV ++once source ~/.config/nvim/rc/MyTerminal.vim
augroup END
" ------------------------------------------------------------------------------
" プラグイン管理
" ------------------------------------------------------------------------------
" 標準プラグインの制御
let g:did_install_default_menus = 1
let g:did_install_syntax_menu   = 1
let g:skip_loading_mswin        = 1
let g:loaded_matchit            = 1
let g:loaded_gzip               = 1
let g:loaded_man                = 1
let g:loaded_tarPlugin          = 1
let g:loaded_tutor_mode_plugin  = 1
let g:loaded_zipPlugin          = 1
let g:loaded_netrwPlugin        = 1
let g:loaded_remote_plugins     = 1
let g:did_load_ftplugin         = 1
let g:loaded_shada_plugin       = 1
let g:loaded_spellfile_plugin   = 1
let g:loaded_tarPlugin          = 1
let g:did_indent_on             = 1
" 標準プラグインの遅延読み込み
call MyFunctions#lazy_load()

" 外部プラグイン管理
" FIXME: 相対パスで書けないのか？
source ~/.config/nvim/plugins.vim
