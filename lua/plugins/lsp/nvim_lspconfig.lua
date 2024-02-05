local M = {}

function M.lua_source()
  require("lspconfig").lua_ls.setup({})
end

return M
