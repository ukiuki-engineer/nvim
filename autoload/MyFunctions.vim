" ================================================================================
" 関数
" ================================================================================
" :TermHere用
function! MyFunctions#termHere() abort
  if expand('%') != ''
    " 無名バッファではない場合にカレントバッファのディレクトリに移動
    lcd %:h
  endif
  T
endfunction

" 標準プラグイン読み込み
function! MyFunctions#Packadd(timer) abort
  unlet g:loaded_matchit
  unlet g:loaded_matchparen
  packadd matchit
endfunction
