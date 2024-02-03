local opts = { noremap = true, silent = true }

local M    = {}

function M.lua_add()
  vim.keymap.set({ "n", "x" }, "<F5>", ":QuickRun<CR>", opts)
end

return M
