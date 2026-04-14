local M = {}

function M.set_customcolor()
  local hi                = vim.api.nvim_set_hl
  local colorscheme_utils = require("plugins.colorscheme.utils")

  -- background colorを取得
  local bg_color          = colorscheme_utils.get_background()

  -- 変更行の変更箇所
  hi(0, 'DiffText', {
    bg = colorscheme_utils.transparent_color(bg_color, "#FD7E00", 0.40)
  })
  -- ヤンク範囲
  hi(0, 'HighlightedyankRegion', {
    bg = colorscheme_utils.transparent_color(bg_color, "#FD7E00", 0.65)
  })
  -- 検索系
  hi(0, 'CurSearch', {
    reverse = true,
    fg = "#FABD2F",
    bg = "#282828",
  })
  hi(0, 'IncSearch', {
    bg = colorscheme_utils.transparent_color(bg_color, "#FABD2F", 0.60),
  })
  hi(0, 'Search', { link = "IncSearch" })
  -- markdown: 太字を目立つ赤にする（Tree-sitter / 従来構文の両対応）
  hi(0, '@markup.strong', { fg = "#cc241d", bold = true })
  hi(0, 'markdownBold', { fg = "#cc241d", bold = true })
  -- vim-matchup用
  hi(0, 'MatchParen', {
    bg = colorscheme_utils.transparent_color(bg_color, "LightGrey", 0.60),
    fg = "Magenta",
    bold = true,
    underline = false
  })
  hi(0, 'MatchWord', { link = "MatchParen" })
  hi(0, 'MatchWordCur', { link = "MatchParen" })
  -- coc.nvim用
  colorscheme_utils.hi_coc_colors(bg_color)
  -- gitsigns用
  colorscheme_utils.hi_gitsigns()
  -- telescope用
  colorscheme_utils.hi_telescope()
end

return M
