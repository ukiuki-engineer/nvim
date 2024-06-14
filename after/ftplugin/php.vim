" phpのインデントは4
lua << EOF
  require("utils.utils").setlocal_indent(4)
EOF
" 行末にセミコロンを挿入
nnoremap <silent> <buffer> <leader>; :call utils#utils#append_semicolon()<CR>

