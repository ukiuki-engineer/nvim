local M = {}

function M.lua_source()
  vim.fn["plugins#hook_source_autoclose"]()
end

return M
