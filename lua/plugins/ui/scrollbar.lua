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
  -- TODO: 設定する。Macだとsattelite使ってるとvimが頻繁にクラッシュするから急いでこっちに乗り換えた。まだ全然設定してない。
  require('scrollbar').setup({})
end

return M
