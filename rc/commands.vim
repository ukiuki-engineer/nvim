" ================================================================================
" commands.vim
" ================================================================================
" 2重読み込み防止
if exists('g:vimrc#loaded_commands')
  finish
endif
let g:vimrc#loaded_commands = 1

command! SetCursorLineColumn       :set cursorline cursorcolumn
command! SetNoCursorLineColumn     :set nocursorline nocursorcolumn
command! SourceSession             :silent! source Session.vim
command! -bang MksessionAndQuitAll :mksession! | :qa<bang>
command! ShowVimrcInfo             :echo system(g:init_dir .. '/tools/show-vimrc-info.sh')
command! OpenVimrc                 :tabnew | :tcd ~/.config/nvim

