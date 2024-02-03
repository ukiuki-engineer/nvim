local M = {}

function M.lua_source()
  -- fn["plugins#hook_source_previm"]()
  vim.g.previm_show_header = 1
  vim.g.previm_enable_realtime = 1
  if os.getenv('PREVIM_OPEN_CMD') then
    vim.g.previm_open_cmd = os.getenv('PREVIM_OPEN_CMD')
  end
end

return M
