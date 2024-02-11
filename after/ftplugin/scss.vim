function! s:echo_warning() abort
  echohl WarningMsg 
  echo "Warning: 'sass' command is not available." 
  echohl None
endfunction

augroup SassAutoCommands
  autocmd!
  if executable('sass')
    " 保存時に自動compile
    autocmd BufWritePost *.scss !sass %:p %:p:h/%:t:r.css
  else
    " sassコマンドが無い場合警告
    autocmd BufWritePost *.scss call s:echo_warning()
  endif
augroup END
