" ================================================================================
" Others
" ================================================================================
"
" vim-quickrun
"
function! plugins#others#hook_add_quickrun() abort
  nnoremap <F5> :QuickRun<CR>
  xnoremap <F5> :QuickRun<CR>
endfunction

"
" vimhelpgenerator
"
function! plugins#others#hook_source_vimhelpgenerator() abort
  let g:vimhelpgenerator_defaultlanguage = 'ja'
  let g:vimhelpgenerator_version = ''
  let g:vimhelpgenerator_author = 'Author  : ukiuki-engineer'
  let g:vimhelpgenerator_contents = {
    \ 'contents': 1, 'introduction': 1, 'usage': 1, 'interface': 1,
    \ 'variables': 1, 'commands': 1, 'key-mappings': 1, 'functions': 1,
    \ 'setting': 0, 'todo': 1, 'changelog': 0
    \}
endfunction

"
" toggleterm
" FIXME: <C-w>L<C-w>Jとするとサイズがバグる
"
function! plugins#others#hook_add_toggleterm() abort
  tnoremap <silent> <C-`> <Cmd>ToggleTerm<CR>
  nnoremap <silent> <C-`> :ToggleTerm<CR>
endfunction

function! plugins#others#hook_source_toggleterm() abort
lua << END
  -- vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]])
  require("toggleterm").setup{
    persist_size = false
  }
END
  " カレントバッファのディレクトリでterminalを開く
  command! ToggleTermHere ToggleTerm dir=%:h
endfunction

"
" fzf.vim
"
function! plugins#others#hook_add_fzf() abort
  let g:fzf_commands_expect = 'alt-enter,ctrl-x'
  " nnoremap <C-p> :Files<CR>
  nnoremap <space>f :Files<CR>
  nnoremap <space>b :Buffers<CR>
  nnoremap <space>g :Rg<CR>
endfunction

