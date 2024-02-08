local hi                = vim.api.nvim_set_hl
local utils             = require("utils")
local colorscheme_utils = require("plugins.colorscheme.utils")

local M                 = {}

function M.set_customcolor()
  local bg_color = colorscheme_utils.get_background()

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
