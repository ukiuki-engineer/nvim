local M = {}

function M.colorscheme_pre()
  -- 以下、default
  vim.g.moonlight_italic_comments    = false
  vim.g.moonlight_italic_keywords    = false
  vim.g.moonlight_italic_functions   = false
  vim.g.moonlight_italic_variables   = false
  vim.g.moonlight_contrast           = true
  vim.g.moonlight_borders            = false
  vim.g.moonlight_disable_background = false
end

function M.set_customcolor()
  local hi                = vim.api.nvim_set_hl
  local utils             = require("utils")
  local colorscheme_utils = require("plugins.colorscheme.utils")

  local bg_color          = colorscheme_utils.get_background()

  colorscheme_utils.hi_diff_by_own_colors(bg_color)
  colorscheme_utils.hi_search(bg_color)
  colorscheme_utils.hi_yank_region(bg_color)

  -- vim-matchup
  hi(0, 'MatchParen', {
    bg = utils.transparent_color(bg_color, "LightGrey", 0.60),
    fg = "#ff9e64",
    bold = true,
    underline = false
  })
  hi(0, 'MatchWord', { link = "MatchParen" })
  hi(0, 'MatchWordCur', { link = "MatchParen" })
end

return M
