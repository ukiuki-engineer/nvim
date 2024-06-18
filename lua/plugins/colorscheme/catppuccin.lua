local M = {}

function M.set_customcolor()
  local colorscheme_utils = require('plugins.colorscheme.utils')
  -- 背景色を取得
  local bg_color = colorscheme_utils.get_background()

  -- ヤンク範囲
  colorscheme_utils.hi_yank_region(bg_color)

  -- 差分系
  -- 変更行の変更箇所のみ見づらかったので変更。他の差分系の色はそのままで。
  vim.api.nvim_set_hl(0, 'DiffText', {
    bg = colorscheme_utils.transparent_color(bg_color, "#FD7E00", 0.7)
  })
end

return M
