local fn = vim.fn
local M = {}

function M.lua_add_coc()
  fn["plugins#hook_add_coc"]()
end

function M.lua_source_coc()
  fn["plugins#hook_source_coc"]()
end

return M
