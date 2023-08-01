" ================================================================================
" IME切り替え
" ================================================================================
" ------------------------------------------------------------------------------
" 2重読み込み防止
" ------------------------------------------------------------------------------
if exists('g:vimrc#loaded_my_ime')
  finish
endif
let g:vimrc#loaded_my_ime = 1
" ------------------------------------------------------------------------------
" autocmd
" ------------------------------------------------------------------------------
augroup MyIME
  autocmd!
  " MacOS用
  if has('mac') && exepath('im-select') != ""
    " NOTE: im-selectをインストールしてPATHを通しておく
    autocmd InsertLeave,InsertEnter,CmdlineLeave * :call jobstart('im-select com.apple.keylayout.ABC')
  endif
  " WSL用
  if has('linux') && exists('$WSLENV') && exepath('zenhan.exe') != ""
    " NOTE: zenhanをインストールしてPATHを通しておく
    autocmd InsertLeave,InsertEnter,CmdlineLeave * :call jobstart('zenhan.exe 0')
  endif
augroup END
