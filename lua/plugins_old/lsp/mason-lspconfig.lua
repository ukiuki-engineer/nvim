local M = {}

function M.lua_source()
  require("mason-lspconfig").setup({
    ensure_installed = {
      "lua_ls",
    },
  })
end

return M
