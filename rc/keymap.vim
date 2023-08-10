" ================================================================================
" keymap.vim
" ================================================================================
let g:mapleader = "m"
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
nnoremap <silent> <TAB> :bn<CR>
nnoremap <silent> <S-TAB> :bN<CR>
" nnoremap <C-j> 7j
" nnoremap <C-k> 7k
xnoremap <C-j> 7j
xnoremap <C-k> 7k
" commandlineモードをemacsライクに {{{
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>
" }}}
lua << END
  require('utils').jump_to_zenkaku({
    [","] = "、",
    ["."] = "。",
    ["("] = "（",
    [")"] = "）",
    ["["] = "「",
    ["]"] = "」",
    ["{"] = "『",
    ["]"] = "』",
    [":"] = "：",
    [";"] = "；",
    ["?"] = "？",
    ["a"] = "あ",
    ["i"] = "い",
    ["u"] = "う",
    ["e"] = "え",
    ["o"] = "お",
  })
END

