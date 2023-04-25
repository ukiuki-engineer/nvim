" ================================================================================
" クリップボード設定
" ================================================================================
" 2重読み込み防止
if exists('g:vimrc#loaded_my_clipboard')
  finish
endif
let g:vimrc#loaded_my_clipboard = 1

if has('linux') && exists('$WSLENV') && exepath('zenhan.exe') != ""
  " WSLの場合何故かclipboardが重いのでtimer遅延させる(急に重くなったから今だけかも)
  call timer_start(1000, { tid -> execute("set clipboard+=unnamedplus") })
else
  set clipboard+=unnamed
endif

