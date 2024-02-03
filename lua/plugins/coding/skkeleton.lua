local M = {}

-- NOTE: lua化保留
function M.lua_add()
  vim.fn["plugins#hook_add_skkeleton"]()
end

-- NOTE: lua化保留
function M.lua_source()
  vim.fn["plugins#hook_source_skkeleton"]()
end

return M
