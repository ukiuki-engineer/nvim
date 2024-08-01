local M = {}

function M.set_customcolor()
  local colorscheme_utils = require('plugins.colorscheme.utils')
  -- 背景色を取得
  local bg_color = colorscheme_utils.get_background()

  -- 差分系
  -- 変更行の変更箇所
  vim.api.nvim_set_hl(0, 'DiffText', {
    bg = colorscheme_utils.transparent_color(bg_color, "#7fbbb3", 0.35)
  })

  -- 検索系
  vim.api.nvim_set_hl(0, 'IncSearch', {
    bg = colorscheme_utils.transparent_color(bg_color, "#e67e80", 0.50)
  })
  vim.api.nvim_set_hl(0, 'Search', {
    bg = colorscheme_utils.transparent_color(bg_color, "#a7c080", 0.50)
  })

  -- vim-matchup用
  vim.api.nvim_set_hl(0, 'MatchParen', {
    bg = colorscheme_utils.transparent_color(bg_color, "LightGrey", 0.60),
    fg = "#ff9e64",
    bold = true,
    underline = false
  })
  vim.api.nvim_set_hl(0, 'MatchWord', { link = "MatchParen" })
  vim.api.nvim_set_hl(0, 'MatchWordCur', { link = "MatchParen" })
end

return M
