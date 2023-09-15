-- ================================================================================
-- colorscheme
-- ================================================================================
local hi    = vim.api.nvim_set_hl
local utils = require("utils")
local const = vim.g["my#const"]

local function diff_transparent_by_own_colors(bg_color)
  -- TODO: utils.get_highlight_color()の結果がnilの場合に対応させる
  -- 追加された行
  hi(0, 'DiffAdd', {
    bg = utils.transparent_color(bg_color, utils.get_highlight_color('DiffAdd', 'guibg'), 0.85)
  })
  -- 変更行
  hi(0, 'DiffChange', {
    bg = utils.transparent_color(bg_color, utils.get_highlight_color('DiffChange', 'guibg'), 0.85)
  })
  -- 削除された行
  hi(0, 'DiffDelete', {
    bg = utils.transparent_color(bg_color, utils.get_highlight_color('DiffDelete', 'guibg'), 0.85)
  })
  -- 変更行の変更箇所
  hi(0, 'DiffText', {
    bg = utils.transparent_color(bg_color, utils.get_highlight_color('DiffText', 'guibg'), 0.60)
  })
end

local function diff_transparent(bg_color)
  -- 追加された行
  hi(0, 'DiffAdd', {
    bg = utils.transparent_color(bg_color, "DarkGreen", 0.80)
  })
  -- 変更行
  hi(0, 'DiffChange', {
    bg = utils.transparent_color(bg_color, "Yellow", 0.80)
  })
  -- 削除された行
  hi(0, 'DiffDelete', {
    bg = utils.transparent_color(bg_color, "Red", 0.80)
  })
  -- 変更行の変更箇所
  hi(0, 'DiffText', {
    bg = utils.transparent_color(bg_color, "#FD7E00", 0.60)
  })
  -- gitsigns.nvim
  hi(0, 'GitSignsCurrentLineBlame', { link = "comment" })
  hi(0, 'GitSignsAdd', { fg = "LightGreen" })
  hi(0, 'GitSignsChange', { fg = "Yellow" })
  hi(0, 'GitSignsDelete', { fg = "Red" })
end

local M = {}

--
-- ハイライト色のカスタムをその時の背景色に応じてセットする
-- 大体のcolorscheme用の設定はここにまとめる
-- 分けた方が良いやつは別メソッドに切り出す
--
function M.set_customcolor()
  -- TODO: (TODO, FIXME, NOTE)について、どのファイルでもハイライトされるようにする

  -- カラースキーム
  local colorscheme = vim.g.colors_name

  if colorscheme == "pink-panic" then
    return
  end

  -- background colorを取得
  local bg_color = M.get_background()

  -- 差分
  if utils.in_array(colorscheme, {
        "gruvbox",
        "moonlight",
        "nightfly",
        "nord",
      }) then
    diff_transparent_by_own_colors(bg_color)
  elseif utils.in_array(colorscheme, { "sonokai" }) then
    diff_transparent(bg_color)
  end

  -- coc.nvim
  local not_target_colorschemes = {
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
    -- 透け透けにする
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
  })
end

-- tokyonight*が設定された後に行う処理
-- NOTE: 基本透け透けで使用する前提
function M.colorscheme_tokyonight()
  -- TODO: diffviewとgitsignsを綺麗に調整する
  -- tokyonight系はかっこ良いけど色々見づらいから結構調整要るなぁ...

  -- background colorを取得
  local bg_color = M.get_background()

  -- hi(0, 'Comment', { fg = "#565f89" })
  hi(0, 'Comment', { fg = "#8a92b6" })

  -- hi(0, 'Visual', { bg = "#283457" })
  hi(0, 'Visual', { bg = "#394b7d" })
  hi(0, 'CursorLine', {
    bg = utils.transparent_color(bg_color, "Magenta", 0.60),
  })
  hi(0, 'CursorColumn', { link = "CursorLine" })

  -- 行番号
  hi(0, 'LineNr', { fg = "#515a84" })
  -- 行番号(カーソル行)
  hi(0, 'CursorLineNr', { fg = "#959ab8" })

  -- 差分
  diff_transparent(bg_color)

  -- coc.nvim
  hi(0, 'HighlightedyankRegion', {
    bg = utils.transparent_color(bg_color, "Yellow", 0.60),
  })
  hi(0, 'CocMenuSel', { link = "Visual" })

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

-- background colorを取得する
function M.get_background()
  -- guibg の値を取得
  local bg_color = utils.get_highlight_color('Normal', 'guibg')
  -- guibgが無しの場合は定数の値を使用
  if bg_color == nil then
    bg_color = const.term_bgcolor
  end
  return bg_color
end

return M
