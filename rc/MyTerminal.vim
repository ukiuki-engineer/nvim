" ================================================================================
" :terminal周りの設定
" ================================================================================
" ------------------------------------------------------------------------------
" autocmd
" ------------------------------------------------------------------------------
augroup MyTerminal
  autocmd!
  " 常にインサートモードで開く
  autocmd TermOpen * startinsert
augroup END
" ------------------------------------------------------------------------------
" キーマッピング
" ------------------------------------------------------------------------------
" ノーマルモードへの入り方は素vimと同じキーマップを採用
tnoremap <C-w>N <C-\><C-n>
" ノーマルモードを経由しなくても色々操作できるように
tnoremap <C-w>h <Cmd>wincmd h<CR>
tnoremap <C-w>j <Cmd>wincmd j<CR>
tnoremap <C-w>k <Cmd>wincmd k<CR>
tnoremap <C-w>l <Cmd>wincmd l<CR>
tnoremap <C-w>H <Cmd>wincmd H<CR>
tnoremap <C-w>J <Cmd>wincmd J<CR>
tnoremap <C-w>K <Cmd>wincmd K<CR>
tnoremap <C-w>L <Cmd>wincmd L<CR>
" ------------------------------------------------------------------------------
" コマンド定義
" ------------------------------------------------------------------------------
" :Term, :TermV
" →ウィンドウを分割してターミナルを開く
command! -nargs=* Term split | wincmd j | resize 20 | terminal <args>
command! -nargs=* TermV vsplit | wincmd l | terminal <args>
" :TermHere, :TermHereV
" →カレントバッファのディレクトリ&ウィンドウを分割してターミナルを開く
command! TermHere :call MyFunctions#term_here("sp")
command! TermHereV :call MyFunctions#term_here("vsp")
