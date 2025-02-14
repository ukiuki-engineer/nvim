local M = {}

function M.lua_source()
  vim.g.matchup_matchpref = {
    html            = { tagnameonly = 1 },
    xml             = { tagnameonly = 1 },
    blade           = { tagnameonly = 1 },
    vue             = { tagnameonly = 1 },
    typescriptreact = { tagnameonly = 1 },
    javascript      = { tagnameonly = 1 },
    javascriptreact = { tagnameonly = 1 },
  }
end

return M
