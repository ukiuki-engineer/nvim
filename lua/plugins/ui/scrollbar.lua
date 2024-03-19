local M = {}

function M.timer_start(time)
  vim.fn.timer_start(
    time,
    function()
      M.lua_add()
    end
  )
end

function M.lua_add()
  require('scrollbar').setup({})
end

return M
