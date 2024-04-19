local M = {}

function M.lua_add()
  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
end

function M.lua_source()
  require("oil").setup({})
end

return M
