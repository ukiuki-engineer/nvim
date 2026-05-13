local M = {}

function M.lua_source()
  require('render-markdown').setup({
    anti_conceal = {
      -- カーソル行の描画キャンセル
      enabled = false,
    },
    heading = {
      position = 'inline',
      left_margin = 0,
      left_pad = 0,
      right_pad = 0,
      width = 'block',
    },
    indent = {
      enabled = false,
    },
  })
end

return M
