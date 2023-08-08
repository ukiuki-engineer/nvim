" ================================================================================
" クリップボード設定
" ================================================================================
" 2重読み込み防止
if exists('g:vimrc#loaded_clipboard')
  finish
endif
let g:vimrc#loaded_clipboard = 1

if has('linux') && exists('$WSLENV')
  " WSLの場合clipboardが重いのでtimer遅延させる
  call timer_start(1000, { tid -> execute("set clipboard+=unnamedplus") })
else
  set clipboard+=unnamed
endif

