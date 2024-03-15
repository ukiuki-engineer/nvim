" phpのインデントは4
lua << EOF
  require("utils").setlocal_indent(4)
EOF
" 行末にセミコロンを挿入
nnoremap <silent> <buffer> <leader>; :call utils#append_semicolon()<CR>

