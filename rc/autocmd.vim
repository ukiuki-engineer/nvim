" ================================================================================
" autocmd.vim
" ================================================================================
augroup MyVimrc
  autocmd!
  " Laravelが4なのでphpは4に
  autocmd FileType php setlocal tabstop=4 shiftwidth=4 softtabstop=4
  " FIXME: markdownだけ何故かインデン4になってしまうので一旦強制的に2に。後で原因を調べる。
  autocmd FileType markdown setlocal tabstop=2 shiftwidth=2 softtabstop=2
  " .env系はシェルスクリプトとして開く
  autocmd BufRead .env,.env.* setlocal filetype=sh
  " CursorHold時のみカーソル行/列を表示
  " autocmd CursorHold * call utils#set_cursor_line_column()
augroup END

