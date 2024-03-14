local M = {}

function M.lua_add()
  vim.g.nightflyNormalFloat         = true
  vim.g.nightflyWinSeparator        = 2
  vim.g.nightflyTransparent         = true
  vim.g.nightflyUnderlineMatchParen = true
end

function M.set()
  M.lua_add()
  vim.cmd([[colorscheme nightfly]])
end

function M.set_customcolor()
  -- g:nightflyTransparentをtrueにするなら以下が必要
  require("notify").setup({
    background_colour = "#000000",
  })

  local colorscheme_utils = require('plugins.colorscheme.utils')
  -- 背景色を取得
  local bg_color = colorscheme_utils.get_background()

  -- 差分系
  colorscheme_utils.hi_diff(bg_color)
  -- 検索系
  colorscheme_utils.hi_search(bg_color)
  -- ヤンク範囲
  colorscheme_utils.hi_yank_region(bg_color)
  -- FloatBorder
  vim.api.nvim_set_hl(0, 'FloatBorder', { fg = "DarkRed" })
  -- カーソル行/列
  -- default: #092236
  vim.api.nvim_set_hl(0, 'CursorLine', {
    bg = colorscheme_utils.transparent_color(bg_color, "#154d81", 0.60),
  })
  vim.api.nvim_set_hl(0, 'CursorColumn', { link = "CursorLine" })
  -- Visual
  vim.api.nvim_set_hl(0, 'Visual', {
    bg = colorscheme_utils.transparent_color(bg_color, "#378ede", 0.60),
  })
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
