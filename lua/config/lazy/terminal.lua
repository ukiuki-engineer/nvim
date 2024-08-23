-- ================================================================================
-- Terminal Modeの設定
-- 基本的にvimの使用感に寄せてる
-- ================================================================================
if vim.g['vimrc#loaded_terminal'] then
  return
end
vim.g['vimrc#loaded_terminal'] = true

local api                      = vim.api
local augroup                  = api.nvim_create_augroup
local au                       = api.nvim_create_autocmd

augroup("my_terminal", {})
au("TermOpen", {
  group = "my_terminal",
  command = "startinsert"
})

local opts = { noremap = true, silent = true }
-- NOTE: vimと違って、Normalモード中にpでペーストできる
vim.keymap.set("t", "<C-w>", "<C-\\><C-n><C-w>", opts)

vim.cmd([[
  " ウィンドウを分割してターミナルを開く
  command! -nargs=* Terminal split | wincmd j | resize 20 | terminal <args>
  command! -nargs=* Term Terminal <args>
  command! -nargs=* TermV vsplit | wincmd l | terminal <args>
  " カレントバッファのディレクトリ&ウィンドウを分割してターミナルを開く
  command! TermHere :call utils#terminal#term_here("sp")
  command! TermHereV :call utils#terminal#term_here("vsp")
]])
