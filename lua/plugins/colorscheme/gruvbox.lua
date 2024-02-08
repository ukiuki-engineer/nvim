local M = {}

function M.set_customcolor()
  local hi                = vim.api.nvim_set_hl
  local utils             = require("utils")
  local colorscheme_utils = require("plugins.colorscheme.utils")

  -- background colorを取得
  local bg_color          = colorscheme_utils.get_background()

  hi(0, 'DiffText', {
    bg = utils.transparent_color(bg_color, "#FABD2F", 0.50)
  })

  hi(0, 'HighlightedyankRegion', {
    bg = utils.transparent_color(bg_color, "#FD7E00", 0.65)
  })

  hi(0, 'CurSearch', {
    reverse = true,
    fg = "#FABD2F",
    bg = "#282828",
  })
  hi(0, 'IncSearch', {
    bg = utils.transparent_color(bg_color, "#FABD2F", 0.60),
  })
  hi(0, 'Search', { link = "IncSearch" })

  colorscheme_utils.hi_coc_colors(bg_color)
  colorscheme_utils.hi_matchup(bg_color)
  colorscheme_utils.hi_gitsigns()
  colorscheme_utils.hi_telescope()
end

return M
