if !exists('g:my#auto_sass_compiling')
  " デフォルト=false
  let g:my#auto_sass_compiling = v:false
endif

" auto sass compileのオン/オフをtoggleする
function! s:auto_sass_compile_toggle() abort
  if !g:my#auto_sass_compiling
    " ONにする
    let g:my#auto_sass_compiling = v:true
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
    echomsg "Auto Sass Compileをオンにしました。"
  else
    " OFFにする
    let g:my#auto_sass_compiling = v:false
    augroup SassAutoCommands
      autocmd!
    augroup END
    echomsg "Auto Sass Compileをオフにしました。"
  endif
endfunction

" sassコマンドが無い場合の警告を表示する
function! s:echo_warning() abort
  echohl WarningMsg
  echomsg "Warning: 'sass' command is not available."
  echohl None
endfunction

command! AutoSassCompilingToggle call s:auto_sass_compile_toggle()

" 行末にセミコロンを挿入
nnoremap <silent> <buffer> <leader>; :call utils#append_semicolon()<CR>
