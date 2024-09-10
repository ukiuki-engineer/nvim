local M = {}

function M.lua_source()
  require("oil").setup({
    win_options = {
      signcolumn = "yes:2",
    },
    view_options = {
      show_hidden = true,
    }
  })
end

return M
