local M = {}

function M.lua_source()
  -- TODO: 作業中
  local mason_null_ls = require('mason-null-ls')
  mason_null_ls.setup({
    ensure_installed = {
      { 'stylua', version = 'v0.14.2' },
    },
    automatic_installation = true,
  })
  mason_null_ls.check_install(true)
end

return M
