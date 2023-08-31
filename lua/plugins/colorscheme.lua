-- ================================================================================
-- colorscheme
-- ================================================================================
local hi    = vim.api.nvim_set_hl
local utils = require("utils")

local M     = {}

--
-- gruvbox.nvim
--
function M.lua_add_gruvbox()
  vim.o.background = "dark"
  vim.cmd([[colorscheme gruvbox]])
end

--
-- vim-nightfly-colors
--
function M.lua_add_nightfly_colors()
  vim.cmd([[colorscheme nightfly]])
end

--
-- nightfox.nvim
--
function M.lua_add_nightfox()
  vim.cmd([[colorscheme nightfox]])
end

--
-- catppuccin.nvim
--
function M.lua_add_catppuccin()
  vim.cmd([[colorscheme catppuccin]])
end

--
-- ハイライト色をカスタムする
--
-- @param string bg_color `:hi normalの値を入れる`
-- @param string colorscheme
--
function M.set_customcolor(bg_color, colorscheme)
  -- TODO: (TODO, FIXME, NOTE)について、どのファイルでもハイライトされるようにする

  -- diffview
  if colorscheme ~= 'nightfox' then
    hi(0, 'DiffviewDiffAddAsDelete', { -- NOTE: 不明
      bg = "#FF0000"
    })
    hi(0, 'DiffDelete', { -- 削除された行
      bg = utils.transparent_color(bg_color, "#C70000", 0.90)
    })
    hi(0, 'DiffviewDiffDelete', {
      -- 行が追加された場合の左側
      bg = utils.transparent_color(bg_color, "#C70000", 0.90),
      fg = colorscheme == 'gruvbox'
          and require("gruvbox.palette").colors.dark2
          or utils.transparent_color(bg_color, "#2F2F2F", 0.00)
    })
    hi(0, 'DiffAdd', { -- 追加された行
      bg = utils.transparent_color(bg_color, "#00A100", 0.85)
    })
    hi(0, 'DiffChange', { -- 変更行
      bg = utils.transparent_color(bg_color, "#B9C42F", 0.80)
    })
    hi(0, 'DiffText', { -- 変更行の変更箇所
      bg = utils.transparent_color(bg_color, "#FD7E00", 0.60)
    })
  end

  -- coc.nvim
  hi(0, 'CocFadeOut', {
    bg = utils.transparent_color(bg_color, '#ADABAC', 0.50),
    fg = "LightGrey"
  })
  hi(0, 'CocHintSign', { fg = "LightGrey" })
  hi(0, 'CocHighlightText', {
    bg = utils.transparent_color(bg_color, "LightGrey", 0.75),
  })
  if colorscheme == 'gruvbox' then
    hi(0, 'HighlightedyankRegion', {
      bg = utils.transparent_color(bg_color, "#FD7E00", 0.65)
    })
  else
    hi(0, 'HighlightedyankRegion', {
      bg = utils.transparent_color(bg_color, "Magenta", 0.65),
    })
  end

  -- vim-matchup
  hi(0, 'MatchParen', {
    bg = utils.transparent_color(bg_color, "LightGrey", 0.75),
    bold = true,
    underline = false
  })
  hi(0, 'MatchWord', { link = "MatchParen" })
  hi(0, 'MatchWordCur', { link = "MatchParen" })

  -- search
  if colorscheme == 'gruvbox' then
    hi(0, 'CurSearch', {
      reverse = true,
      fg = "#FABD2F",
      bg = "#282828",
    })
    hi(0, 'IncSearch', {
      bg = utils.transparent_color(bg_color, "#FABD2F", 0.70),
    })
    hi(0, 'Search', {
      link = "IncSearch"
    })
  end

  -- gitsigns.vim
  hi(0, 'GitSignsCurrentLineBlame', {
    link = "comment"
  })
end

return M
