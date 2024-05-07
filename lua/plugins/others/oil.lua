local M = {}

function M.lua_source()
  require("oil").setup({
    win_options = {
      signcolumn = "yes:2",
    },
  })
end

return M
