local M = {}

function M.lua_source()
  vim.keymap.set({ 'n', 'x' }, '<C-j>', '<Plug>(edgemotion-j)', { silent = true })
  vim.keymap.set({ 'n', 'x' }, '<C-k>', '<Plug>(edgemotion-k)', { silent = true })
end

return M
