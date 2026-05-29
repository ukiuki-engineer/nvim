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

  vim.keymap.set('n', '<leader>rt', '<Cmd>RenderMarkdown toggle<CR>', { desc = 'RenderMarkdown toggle' })
end

return M
