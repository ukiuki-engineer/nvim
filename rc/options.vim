" ================================================================================
" options.vim
" ================================================================================
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

