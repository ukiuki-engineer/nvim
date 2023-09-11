-- ================================================================================
-- colorscheme
-- ================================================================================
local hi    = vim.api.nvim_set_hl
local utils = require("utils")
local const = vim.g["my#const"]

local M     = {}

--
-- ハイライト色のカスタムをその時の背景色に応じてセットする
-- 大体のcolorscheme用の設定はここにまとめる
-- 分けた方が良いやつは別メソッドに切り出す
--
function M.set_customcolor()
  -- TODO: (TODO, FIXME, NOTE)について、どのファイルでもハイライトされるようにする

  -- カラースキーム
  local colorscheme = vim.g.colors_name

  -- background colorを取得
  local bg_color = M.get_background()

  -- diffview
  local not_target_colorschemes = {
    "carbonfox",
    "catppuccin",
    "catppuccin-frappe",
    "catppuccin-latte",
    "catppuccin-macchiato",
    "catppuccin-mocha",
    "dayfox",
    "monokai",
    "nightfox",
    "nordfox",
    "terafox",
    "tokyonight",
  }
  if not utils.in_array(colorscheme, not_target_colorschemes) then
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
  not_target_colorschemes = {
    "monokai",
  }
  if not utils.in_array(colorscheme, not_target_colorschemes) then
    hi(0, 'CocFadeOut', {
      bg = utils.transparent_color(bg_color, "#ADABAC", 0.60),
      fg = "DarkGray"
    })
    hi(0, 'CocHintSign', { fg = "LightGrey" })
    hi(0, 'CocHighlightText', {
      bg = utils.transparent_color(bg_color, "LightGrey", 0.75),
    })
  end
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
    hi(0, 'Search', { link = "IncSearch" })
  end

  -- gitsigns.nvim
  hi(0, 'GitSignsCurrentLineBlame', { link = "comment" })
end

-- tokyonight*が設定される前に行う処理
function M.colorschemepre_tokyonight()
  require("tokyonight").setup({
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
  })
end

-- tokyonight*が設定された後に行う処理
function M.colorscheme_tokyonight()
  -- background colorを取得
  local bg_color = M.get_background()

  -- hi(0, 'Comment', { fg = "#565f89" })
  hi(0, 'Comment', { fg = "#8a92b6" })

  -- coc.nvim
  hi(0, 'HighlightedyankRegion', {
    bg = utils.transparent_color(bg_color, "Magenta", 0.60),
  })

  -- gitsigns.nvim
  hi(0, 'GitSignsCurrentLineBlame', { link = "comment" })
  hi(0, 'GitSignsAdd', { fg = "LightGreen" })
  hi(0, 'GitSignsChange', { fg = "Yellow" })
  hi(0, 'GitSignsDelete', { fg = "Red" })
end

-- background colorを取得する
function M.get_background()
  -- guibg の値を取得
  local bg_color = string.match(vim.fn.execute('hi normal'), "guibg=(#%x+)")
  -- guibgが無しの場合は定数の値を使用
  if bg_color == "" or bg_color == nil then
    bg_color = const.term_bgcolor
  end
  return bg_color
end

return M
