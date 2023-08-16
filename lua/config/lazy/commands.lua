if vim.g['vimrc#loaded_commands'] then
  return
end
vim.g['vimrc#loaded_commands'] = true

-- NOTE: vim.api.nvim_create_user_command()を使うよりこっちの方がシンプル...
vim.cmd([[
  command! SetCursorLineColumn       :set cursorline cursorcolumn
  command! SetNoCursorLineColumn     :set nocursorline nocursorcolumn
  command! SourceSession             :silent! source Session.vim
  command! -bang MksessionAndQuitAll :mksession! | :qa<bang>
  command! ShowVimrcInfo             :echo system(g:init_dir .. '/scripts/show-vimrc-info.sh')
  command! OpenVimrc                 :tabnew | :tcd ~/.config/nvim
  " バッファのフルパスをヤンクする
  command! YankBufPath               :let @0 = expand('%:p') | :let @+ = expand('%:p')
]])
