" ================================================================================
" 関数
" ================================================================================
" :TermHere用
function! MyFunctions#term_here(spOrVsp) abort
  if a:spOrVsp == "sp"      " 水平分割
    split | wincmd j | resize 20
  elseif a:spOrVsp == "vsp" " 垂直分割
    vsplit | wincmd l
  endif
  " 無名バッファではない場合にカレントバッファのディレクトリに移動
  if expand('%') != ''
    lcd %:h
  endif
  " ターミナルを開く
  terminal
endfunction

" ------------------------------------------------------------------------------
" 標準プラグインの遅延読み込み
" ------------------------------------------------------------------------------
function! MyFunctions#lazy_load() abort
  augroup UserTimerLoad
    autocmd!
    execute 'au InsertLeave,FileType * ++once call MyFunctions#PackAdd()'
  augroup END
  if expand('%') != ''
    call timer_start(500, function("s:TimerLoad"))
  endif
endfunction

function! s:TimerLoad(timer) abort
  call MyFunctions#PackAdd()
endfunction

function! MyFunctions#PackAdd() abort
  unlet g:loaded_matchit
  packadd matchit
endfunction
