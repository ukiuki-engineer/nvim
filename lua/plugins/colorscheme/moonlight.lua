local M = {}

function M.colorscheme_pre()
  -- 以下、default
  vim.g.moonlight_italic_comments    = false
  vim.g.moonlight_italic_keywords    = false
  vim.g.moonlight_italic_functions   = false
  vim.g.moonlight_italic_variables   = false
  vim.g.moonlight_contrast           = true
  vim.g.moonlight_borders            = false
  vim.g.moonlight_disable_background = true
end

function M.set_customcolor()
  local hi                = vim.api.nvim_set_hl
  local colorscheme_utils = require("plugins.colorscheme.utils")

  -- 背景色を取得
  local bg_color          = colorscheme_utils.get_background()

  -- 差分系
  colorscheme_utils.hi_diff_by_own_colors(bg_color)
  -- 検索系
  colorscheme_utils.hi_search(bg_color)
  -- ヤンク範囲
  colorscheme_utils.hi_yank_region(bg_color)

  -- Comment
  hi(0, 'Comment', { fg = "#8a92b6" })
  hi(0, 'TSComment', { link = "Comment" })

  -- CursorLine
  hi(0, 'CursorLine', { link = "CursorColumn" })

  -- vim-matchup
  hi(0, 'MatchParen', {
    bg = colorscheme_utils.transparent_color(bg_color, "LightGrey", 0.60),
    fg = "#ff9e64",
    bold = true,
    underline = false
  })
  hi(0, 'MatchWord', { link = "MatchParen" })
  hi(0, 'MatchWordCur', { link = "MatchParen" })
end

return M
