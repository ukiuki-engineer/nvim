" ================================================================================
" 関数
" ================================================================================
" :TermHere用
function! MyFunctions#TermHere(spOrVsp) abort
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
" FIXME: 無名バッファの時だけタイマーロードを外したい
"        packadd実行時にvim起動時に中央に出てくるタイトルみたいなやつが消えてしまうため
function! MyFunctions#LazyLoad() abort
  augroup UserTimerLoad
    autocmd!
  " FIXME: PackAdd()が呼ばれていないっぽい
    autocmd InsertEnter,FileType <once> call MyFunctions#PackAdd()
  augroup END
  if expand('%') != '' || 1 == 1 " FIXME: 1 == 1は仮。後で消す。
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

