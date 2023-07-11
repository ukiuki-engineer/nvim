" ================================================================================
" UI
" ================================================================================
"
" nvim-tree
"
function! plugins#ui#hook_add_nvim_tree() abort
  nnoremap <silent> <C-n> :NvimTreeToggle<CR>
  nnoremap <silent> <C-w>t :NvimTreeFindFile<CR>
endfunction
