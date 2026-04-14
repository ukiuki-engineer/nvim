local M = {}

function M.colorscheme_pre()
  require('kanagawa').setup({
    transparent = false,
  })
end

function M.set_customcolor()
  local hi                = vim.api.nvim_set_hl
  local colorscheme_utils = require('plugins.colorscheme.utils')
  -- 背景色を取得
  local bg_color          = colorscheme_utils.get_background()

  -- 差分系
  colorscheme_utils.hi_diff(bg_color)
  -- 検索系
  colorscheme_utils.hi_search(bg_color)
  -- markdown: 太字を目立つ赤にする（Tree-sitter / 従来構文の両対応）
  hi(0, '@markup.strong', { fg = "#e82424", bold = true })
  hi(0, 'markdownBold', { fg = "#e82424", bold = true })
  -- ヤンク範囲
  colorscheme_utils.hi_yank_region(bg_color)
  -- coc.nvim用
  colorscheme_utils.hi_coc_colors(bg_color)
  -- gitsigns用
  colorscheme_utils.hi_gitsigns()
  -- telescope用
  colorscheme_utils.hi_telescope()
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
