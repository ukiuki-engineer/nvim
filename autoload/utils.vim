" ================================================================================
" 関数
" ================================================================================
"
" :TermHere用
" NOTE: toggletermを使用するためしばらく不使用
"
function! utils#term_here(spOrVsp) abort
  " 水平分割
  if a:spOrVsp == "sp"
    split | wincmd j | resize 20
  " 垂直分割
  elseif a:spOrVsp == "vsp"
    vsplit | wincmd l
  endif
  " ターミナルをカレントバッファのディレクトリで開く
  call utils#execute_here("terminal")
endfunction

"
" カレントバッファのディレクトリに移動してコマンドを実行
"
function! utils#execute_here(command) abort
  " 無名バッファでなければ移動
  if expand('%') != ''
    lcd %:h
  endif
  " コマンド実行
  execute a:command
endfunction

"
" カーソル行/列の表示と非表示
"
function! utils#set_cursor_line_column() abort
  " カーソル行/列を表示
  setlocal cursorline cursorcolumn
  augroup MyCursorLineColumn
    autocmd!
    " カーソル行/列を非表示
    autocmd WinLeave,CursorMoved <buffer> ++once setlocal nocursorline nocursorcolumn
  augroup END
endfunction

"
" 標準プラグインの遅延読み込み
"
function! utils#lazy_load() abort
  augroup MyTimerLoad
    autocmd!
    execute 'au InsertLeave,FileType * ++once call s:packadd()'
  augroup END
  if expand('%') != ''
    call timer_start(500, function("s:timer_load"))
  endif
endfunction

function! s:packadd() abort
  unlet g:loaded_matchit
  packadd matchit
endfunction

function! s:timer_load(timer) abort
  call s:packadd()
endfunction