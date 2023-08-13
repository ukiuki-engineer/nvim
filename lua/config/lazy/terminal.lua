if vim.g['vimrc#loaded_terminal'] then
  return
end
vim.g['vimrc#loaded_terminal'] = true

-- nvim-cmpの設定をリロード
require("plugins.coding").lua_source_nvim_cmp()

local api     = vim.api
local augroup = api.nvim_create_augroup
local au      = api.nvim_create_au

api.nvim_create_augroup("my_terminal", {})
api.nvim_create_autocmd("TermOpen", {
  group = "my_terminal",
  command = "startinsert"
})

-- keymappings {{{
local opts = {noremap = true, silent = true}
-- NOTE: vimと違って、Normalモード中にpでペーストできる
vim.keymap.set("t", "<C-w>", "<C-\\><C-n><C-w>", opts)
-- }}}

-- commands {{{
-- NOTE: vim.api.nvim_create_user_command()を使うよりこっちの方がシンプル...
vim.cmd([[
  " →ウィンドウを分割してターミナルを開く
  command! -nargs=* Terminal split | wincmd j | resize 20 | terminal <args>
  command! -nargs=* Term Terminal <args>
  command! -nargs=* TermV vsplit | wincmd l | terminal <args>
  " →カレントバッファのディレクトリ&ウィンドウを分割してターミナルを開く
  command! TermHere :call utils#term_here("sp")
  command! TermHereV :call utils#term_here("vsp")
]])
-- }}}
