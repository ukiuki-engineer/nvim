local M = {}

function M.lua_add()
  require("tokyonight").setup({
    -- 透け透けにする
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
  })
end

function M.set_customcolor()
  local hi                = vim.api.nvim_set_hl
  local colorscheme_utils = require("plugins.colorscheme.utils")

  -- NOTE: 基本透け透けで使用する前提
  -- TODO: diffviewとgitsignsを綺麗に調整する

  -- background colorを取得
  local bg_color          = colorscheme_utils.get_background()

  -- hi(0, 'Comment', { fg = "#565f89" })
  hi(0, 'Comment', { fg = "#8a92b6" })

  -- hi(0, 'Visual', { bg = "#283457" })
  hi(0, 'Visual', { bg = "#394b7d" })
  hi(0, 'CursorLine', {
    bg = colorscheme_utils.transparent_color(bg_color, "Magenta", 0.60),
  })
  hi(0, 'CursorColumn', { link = "CursorLine" })

  -- 行番号
  hi(0, 'LineNr', { fg = "#515a84" })
  -- 行番号(カーソル行)
  hi(0, 'CursorLineNr', { fg = "#959ab8" })
  -- 差分
  colorscheme_utils.hi_diff(bg_color)

  -- ヤンク範囲
  hi(0, 'HighlightedyankRegion', {
    bg = colorscheme_utils.transparent_color(bg_color, "Yellow", 0.60),
  })
  hi(0, 'CocMenuSel', { link = "Visual" })

  -- vim-matchup
  hi(0, 'MatchParen', {
    bg = colorscheme_utils.transparent_color(bg_color, "LightGrey", 0.60),
    fg = "#ff9e64",
    bold = true,
    underline = false
  })
  hi(0, 'MatchWord', { link = "MatchParen" })
  hi(0, 'MatchWordCur', { link = "MatchParen" })

  -- telescope.nvim
  colorscheme_utils.hi_telescope()
end

return M
