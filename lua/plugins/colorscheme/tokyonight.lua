local M = {}

function M.colorscheme_pre()
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
  -- NOTE: 基本透け透けで使用する前提
  local hi                = vim.api.nvim_set_hl
  local colorscheme_utils = require("plugins.colorscheme.utils")
  -- background colorを取得
  local bg_color          = colorscheme_utils.get_background()

  -- コメント
  hi(0, 'Comment', { fg = "#8a92b6" })

  -- ビジュアル行
  hi(0, 'Visual', { bg = "#394b7d" })

  -- 行番号
  hi(0, 'LineNr', { fg = "#515a84" })

  -- 差分
  colorscheme_utils.hi_diff(bg_color)

  -- ヤンク範囲
  hi(0, 'HighlightedyankRegion', {
    bg = colorscheme_utils.transparent_color(bg_color, "#ff9e64", 0.60),
  })

  -- vim-matchup
  hi(0, 'MatchParen', {
    bg = colorscheme_utils.transparent_color(bg_color, "LightGrey", 0.60),
    fg = "#ff9e64",
    bold = true,
    underline = false
  })
  hi(0, 'MatchWord', { link = "MatchParen" })
  hi(0, 'MatchWordCur', { link = "MatchParen" })

  -- gitsigns
  colorscheme_utils.hi_gitsigns()

  -- telescope.nvim
  colorscheme_utils.hi_telescope()
end

return M
