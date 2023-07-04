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
" previm
"
function! plugins#others#hook_source_previm() abort
  let g:previm_show_header = 1
  let g:previm_enable_realtime = 1
  if has('mac')
    " MacOS用
    let g:previm_open_cmd = 'open -a Google\ Chrome'
  elseif has('linux') && exists('$WSLENV')
    " TODO: WSL用
  endif
endfunction

"
" toggleterm.nvim
" FIXME: <C-w>L<C-w>Jとするとサイズがバグる
"
function! plugins#others#hook_add_toggleterm() abort
  tnoremap <silent> <C-`> <Cmd>ToggleTerm<CR>
  nnoremap <silent> <C-`> :ToggleTerm<CR>
endfunction

function! plugins#others#hook_source_toggleterm() abort
  " カレントバッファのディレクトリでterminalを開く
  command! ToggleTermHere ToggleTerm dir=%:h
endfunction
