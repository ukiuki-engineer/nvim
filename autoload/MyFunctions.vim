" ================================================================================
" 関数
" ================================================================================
" :TermHere用
function! MyFunctions#term_here(spOrVsp) abort
  " 水平分割
  if a:spOrVsp == "sp"
    split | wincmd j | resize 20
  " 垂直分割
  elseif a:spOrVsp == "vsp"
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
    execute 'au InsertLeave,FileType * ++once call MyFunctions#packadd()'
  augroup END
  if expand('%') != ''
    call timer_start(500, function("s:TimerLoad"))
  endif
endfunction

function! s:TimerLoad(timer) abort
  call MyFunctions#packadd()
endfunction

function! MyFunctions#packadd() abort
  unlet g:loaded_matchit
  packadd matchit
endfunction
