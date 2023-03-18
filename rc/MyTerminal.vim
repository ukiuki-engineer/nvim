" ------------------------------------------------------------------------------
" autocmd
" ------------------------------------------------------------------------------
augroup MyTerminal
  autocmd!
  " $B>o$K%$%s%5!<%H%b!<%I$G3+$/(B
  autocmd TermOpen * startinsert
augroup END
" ------------------------------------------------------------------------------
" $B%-!<%^%C%T%s%0(B
" ------------------------------------------------------------------------------
" $B$J$k$Y$/AG(Bvim$B$HF1$8%-!<%^%C%W$K(B
tnoremap <C-w>N     <C-\><C-n>
tnoremap <C-w>h     <Cmd>wincmd h<CR>
tnoremap <C-w>j     <Cmd>wincmd j<CR>
tnoremap <C-w>k     <Cmd>wincmd k<CR>
tnoremap <C-w>l     <Cmd>wincmd l<CR>
tnoremap <C-w>H     <Cmd>wincmd H<CR>
tnoremap <C-w>J     <Cmd>wincmd J<CR>
tnoremap <C-w>K     <Cmd>wincmd K<CR>
tnoremap <C-w>L     <Cmd>wincmd L<CR>
" ------------------------------------------------------------------------------
" $B%3%^%s%IDj5A(B
" ------------------------------------------------------------------------------
" :Term, :TermV
" $B"*%&%#%s%I%&$rJ,3d$7$F%?!<%_%J%k$r3+$/(B
command! -nargs=* Term split | wincmd j | resize 20 | terminal <args>
command! -nargs=* TermV vsplit | wincmd l | terminal <args>
" :TermHere, :TermHereV
" $B"*%+%l%s%H%P%C%U%!$N%G%#%l%/%H%j(B&$B%&%#%s%I%&$rJ,3d$7$F%?!<%_%J%k$r3+$/(B
command! TermHere :call vimrc#term_here("sp")
command! TermHereV :call vimrc#term_here("vsp")
