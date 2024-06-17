local M = {}

function M.set_customcolor()
  local colorscheme_utils = require('plugins.colorscheme.utils')
  -- 背景色を取得
  local bg_color = colorscheme_utils.get_background()

  -- ヤンク範囲
  vim.api.nvim_set_hl(0, 'HighlightedyankRegion', {
    bg = colorscheme_utils.transparent_color(bg_color, "#81b29a", 0.65)
  })

  -- vim-matchup用
  vim.api.nvim_set_hl(0, 'MatchWord', { link = "MatchParen" })
  vim.api.nvim_set_hl(0, 'MatchWordCur', { link = "MatchParen" })

  -- 差分系
  -- 変更行の変更箇所のみ見づらかったので変更。他の差分系の色はそのままで。
  vim.api.nvim_set_hl(0, 'DiffText', {
    bg = colorscheme_utils.transparent_color(bg_color, "#FD7E00", 0.8)
  })
end

return M
