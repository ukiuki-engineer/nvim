" ================================================================================
" init.vim
" ================================================================================
if &modifiable == 1
  set enc=utf-8
  set fenc=utf-8
endif
set helplang=ja           " ヘルプを日本語化
set mouse=a               " マウス有効化
set autoread              " 編集中のファイルが変更されたら自動で読み直す
set cursorline            " カーソル行を表示
set cursorcolumn          " カーソル列を表示
set number                " 行番号を表示
set list                  " タブや改行を表示
" タブや改行の表示記号を定義
set listchars=tab:»-,trail:-,eol:↓,extends:»,precedes:«,nbsp:%
set expandtab             " Tab 文字を半角スペースにする
set shiftwidth=2          " 行頭での Tab 文字の表示幅
set clipboard+=unnamed    " ヤンクした文字列をクリップボードにコピー
set splitright            " 画面を垂直分割する際に右に開く
set splitbelow            " 画面を水平分割する際に下に開く
set nowrapscan            " 検索時にファイルの最後まで行っても最初に戻らない
set ignorecase            " 検索時に大文字小文字を無視
set smartcase             " 大文字小文字の両方が含まれている場合は大文字小文字を区別
" sessionに保存する内容を指定
set sessionoptions=buffers,curdir,tabpages
colorscheme molokai       " カラースキーム
" ファイルタイプ、拡張子毎のインデント設定
augroup UserFileTypeIndent
  autocmd!
  autocmd FileType php setlocal tabstop=4 shiftwidth=4 softtabstop=4
  autocmd BufEnter *.erb setlocal tabstop=2 shiftwidth=2 softtabstop=2
augroup END
" :terminalを常にインサートモードで開く
augroup UserTerminal
  autocmd!
  autocmd TermOpen * startinsert
augroup END
" IME切り替え設定
augroup UserIME
  autocmd!
  if has('mac') && exepath('im-select') != ""
    " macの場合im-selectをインストールしてPATHを通しておく
    autocmd InsertLeave,InsertEnter,BufRead,CmdlineLeave,CmdlineEnter * :call system('im-select com.apple.keylayout.ABC')
  endif
  if !has('mac') && exepath('zenhan.exe') != ""
    " windows(WSL)の場合、zenhanをインストールしてPATHを通しておく
    autocmd InsertLeave,InsertEnter,BufRead,CmdlineLeave,CmdlineEnter * :call system('zenhan.exe 0')
  endif
augroup END
"
" キーマッピング
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
nnoremap <C-c><C-c> :nohlsearch<CR><Esc>
inoremap <C-c> <Esc>
nnoremap <TAB> :bn<Enter>
nnoremap <S-TAB> :bN<Enter>
tnoremap <Esc> <C-\><C-n>

" ------------------------------------------------------------------------------
" プラグイン設定読み込み
source ~/.config/nvim/plugins.vim
