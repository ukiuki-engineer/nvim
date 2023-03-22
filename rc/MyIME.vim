" ================================================================================
" IME切り替え
" ================================================================================
" 基本的には、外部の実行ファイルを叩いてOS側で切り替えを行う方針
" いずれeskk.vimなどに乗り換えるかも
augroup MyIME
  autocmd!
  " MacOS用
  if has('mac') && exepath('im-select') != ""
    " NOTE: im-selectをインストールしてPATHを通しておく
    autocmd InsertLeave,InsertEnter,BufRead,CmdlineLeave,CmdlineEnter * :call system('im-select com.apple.keylayout.ABC')
  endif
  " WSL用
  if !has('mac') && exepath('zenhan.exe') != ""
    " NOTE: zenhanをインストールしてPATHを通しておく
    autocmd InsertLeave,InsertEnter,BufRead,CmdlineLeave,CmdlineEnter * :call system('zenhan.exe 0')
  endif
augroup END

