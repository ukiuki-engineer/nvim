local M = {}

function M.set_customcolor()
  local hi                = vim.api.nvim_set_hl
  local colorscheme_utils = require("plugins.colorscheme.utils")

  -- background colorを取得
  local bg_color          = colorscheme_utils.get_background()

  colorscheme_utils.hi_coc_colors(bg_color)
  colorscheme_utils.hi_gitsigns()
  colorscheme_utils.hi_telescope()

  hi(0, 'DiffText', {
    bg = colorscheme_utils.transparent_color(bg_color, "#FABD2F", 0.50)
  })

  hi(0, 'HighlightedyankRegion', {
    bg = colorscheme_utils.transparent_color(bg_color, "#FD7E00", 0.65)
  })

  hi(0, 'CurSearch', {
    reverse = true,
    fg = "#FABD2F",
    bg = "#282828",
  })
  hi(0, 'IncSearch', {
    bg = colorscheme_utils.transparent_color(bg_color, "#FABD2F", 0.60),
  })
  hi(0, 'Search', { link = "IncSearch" })

  -- vim-matchup用
  vim.api.nvim_set_hl(0, 'MatchParen', {
    bg = colorscheme_utils.transparent_color(bg_color, "LightGrey", 0.60),
    fg = "Magenta",
    bold = true,
    underline = false
  })
  vim.api.nvim_set_hl(0, 'MatchWord', { link = "MatchParen" })
  vim.api.nvim_set_hl(0, 'MatchWordCur', { link = "MatchParen" })
end

return M
