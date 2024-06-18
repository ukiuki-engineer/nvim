local M = {}

function M.lua_source()
  -- NOTE: 事前インストール
  -- brew install luarocks
  require("mason").setup()
end

return M
