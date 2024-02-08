local hi    = vim.api.nvim_set_hl
local utils = require("utils")

local M     = {}

-- background colorを取得する
function M.get_background()
  -- guibg の値を取得
  local bg_color = utils.get_highlight_color('Normal', 'guibg')
  -- guibgが無しの場合は定数の値を使用
  if bg_color == nil then
    bg_color = vim.g["my#const"].term_bgcolor
  end
  return bg_color
end

-- 差分系
function M.hi_diff(bg_color)
  -- 追加された行
  hi(0, 'DiffAdd', {
    bg = utils.transparent_color(bg_color, "DarkGreen", 0.80)
  })
  -- 変更行
  hi(0, 'DiffChange', {
    bg = utils.transparent_color(bg_color, "Yellow", 0.85)
  })
  -- 削除された行
  hi(0, 'DiffDelete', {
    bg = utils.transparent_color(bg_color, "Red", 0.85)
  })
  -- 変更行の変更箇所
  hi(0, 'DiffText', {
    bg = utils.transparent_color(bg_color, "#FD7E00", 0.65)
  })
end

-- 差分系(そのカラースキームで元々定義されている色を使用して再定義)
function M.hi_diff_by_own_colors(bg_color)
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

-- coc.nvimで使用するやつ
function M.hi_coc_colors(bg_color)
  hi(0, 'CocFadeOut', {
    bg = utils.transparent_color(bg_color, "#ADABAC", 0.60),
    fg = "DarkGray"
  })
  hi(0, 'CocHintSign', { fg = "LightGrey" })
  hi(0, 'CocHighlightText', {
    bg = utils.transparent_color(bg_color, "LightGrey", 0.75),
  })
end

function M.hi_yank_region(bg_color)
  hi(0, 'HighlightedyankRegion', {
    bg = utils.transparent_color(bg_color, "Magenta", 0.65),
  })
end

function M.hi_matchup(bg_color)
  hi(0, 'MatchParen', {
    bg = utils.transparent_color(bg_color, "LightGrey", 0.75),
    bold = true,
    underline = false
  })
  hi(0, 'MatchWord', { link = "MatchParen" })
  hi(0, 'MatchWordCur', { link = "MatchParen" })
end

function M.hi_search(bg_color)
  hi(0, 'CurSearch', {
    reverse = true,
    fg = "#FABD2F",
    bg = "#282828",
  })
  hi(0, 'IncSearch', {
    bg = utils.transparent_color(bg_color, "#FABD2F", 0.60),
  })
  hi(0, 'Search', { link = "IncSearch" })
end

function M.hi_gitsigns()
  -- gitsigns.nvim
  hi(0, 'GitSignsCurrentLineBlame', { link = "comment" })
  hi(0, 'GitSignsAdd', { fg = "LightGreen" })
  hi(0, 'GitSignsChange', { fg = "Yellow" })
  hi(0, 'GitSignsDelete', { fg = "Red" })
end

function M.hi_telescope()
  hi(0, 'TelescopePromptCounter', { link = "Comment" })
end

-- とりあえずこれつけとけばOK的なやつ
function M.set_customcolor_common(bg_color)
  if not bg_color then
    bg_color = M.get_background()
  end

  M.hi_diff(bg_color)
  M.hi_coc_colors(bg_color)
  M.hi_yank_region(bg_color)
  M.hi_matchup(bg_color)
  M.hi_gitsigns()
  M.hi_telescope()
  M.hi_search(bg_color)
end

return M
