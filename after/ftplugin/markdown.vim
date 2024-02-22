" コードブロックを挿入
inoremap <buffer> <C-_> ```<CR>```<UP>
" checkboxにcheckを入れる
nnoremap <buffer> <leader>x :s/- \[ \]/- [x]/<CR>
xnoremap <buffer> <leader>x :s/- \[ \]/- [x]/<CR>
" checkboxをuncheckにする
nnoremap <buffer> <leader>X :s/- \[x\]/- [ ]/<CR>
xnoremap <buffer> <leader>X :s/- \[x\]/- [ ]/<CR>
