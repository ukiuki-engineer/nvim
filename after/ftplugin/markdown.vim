" checkboxにcheckを入れる
nnoremap <buffer> <leader>x :s/\[ \]/[x]/ \| nohlsearch<CR>
xnoremap <buffer> <leader>x :s/\[ \]/[x]/ \| nohlsearch<CR>
" checkboxをuncheckにする
nnoremap <buffer> <leader>X :s/\[x\]/[ ]/ \| nohlsearch<CR>
xnoremap <buffer> <leader>X :s/\[x\]/[ ]/ \| nohlsearch<CR>
