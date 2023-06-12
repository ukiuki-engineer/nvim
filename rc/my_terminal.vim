" ================================================================================
" :terminal周りの設定
" NOTE: toggletermと併用してみる
" FIXME: 初回だけ:Termが使えない
"        :Terminalを実行して一回このファイルが読み込まれれば:Termも使えるようになる
" ================================================================================
" ------------------------------------------------------------------------------
" 読み込み時の処理
" ------------------------------------------------------------------------------
" 2重読み込み防止
if exists('g:vimrc#loaded_my_terminal')
  finish
endif
let g:vimrc#loaded_my_terminal = 1

" nvim-cmpの設定をリロード
lua require("plugins.lsp_and_completion").lua_source_nvim_cmp()
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
" NOTE: vimと違って、Normalモード中にpでペーストできる
" ------------------------------------------------------------------------------
" ノーマルモードを経由しなくてもwindows操作可能に
tnoremap <silent> <C-w> <C-\><C-n><C-w>
" ------------------------------------------------------------------------------
" コマンド定義
" ------------------------------------------------------------------------------
" :Term, :TermV
" →ウィンドウを分割してターミナルを開く
command! -nargs=* Terminal split | wincmd j | resize 20 | terminal <args>
command! -nargs=* Term Terminal <args>
command! -nargs=* TermV vsplit | wincmd l | terminal <args>
" :TermHere, :TermHereV
" →カレントバッファのディレクトリ&ウィンドウを分割してターミナルを開く
command! TermHere :call utils#term_here("sp")
command! TermHereV :call utils#term_here("vsp")
