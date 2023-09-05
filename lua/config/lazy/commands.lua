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
  " バッファのフルパスをヤンクする(ホームディレクトリは"~"で表記)
  command! YankBufFullPath           :let @0 = expand('%:~') | :let @+ = expand('%:~')
  " バッファの(:pwdから見た)相対パスをヤンクする
  command! YankBufRelativePath       :let @0 = expand('%') | :let @+ = expand('%')
  " バッファのファイル名をヤンクする
  command! YankBufFileName           :let @0 = expand('%:t') | :let @+ = expand('%:t')
  " git情報を更新する
  command! RefreshGitInfomations     :call utils#refresh_git_infomations()
  " 保存だけ行う(autocmdを発火させない。format on saveとかその他諸々。)
  command! W                         :noautocmd w
]])
