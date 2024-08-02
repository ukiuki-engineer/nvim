local hi = vim.api.nvim_set_hl

local M  = {}

-------------------------------------------------------------------------------
-- utils
-------------------------------------------------------------------------------
---
-- 透過色を16進数で返す
--
-- @param string bg_color 背景色のカラーコード(16進数)
-- @param string target_color 対象色のカラーコード(16進数)
-- @param number alpha 透過率(0.0-1.0)。0に近いほど濃い。1に近いほど薄い。
-- @return string 透過させた色のカラーコード(16進数)
function M.transparent_color(bg_color, target_color, alpha)
  -- target_colorにcolornameが指定されている場合、colorcodeに変換
  if string.sub(target_color, 1, 1) ~= "#" then
    target_color = M.get_colorcode_by_colorname(target_color)
  end

  if string.sub(target_color, 1, 1) ~= "#" and (not target_color or target_color == "") then
    return ''
  end

  local result_color = "#"

  -- 背景色と対象色を10進数に変換して、透過させた色を計算
  for i = 1, 3 do                                                   -- R, G, Bごとに処理
    local bg_hex = string.sub(bg_color, i * 2, (i * 2) + 1)         -- 背景(16進数)
    local bg_dec = tonumber(bg_hex, 16)                             -- 背景(10進数)
    local target_hex = string.sub(target_color, i * 2, (i * 2) + 1) -- 対象(16進数)
    local target_dec = tonumber(target_hex, 16)                     -- 対象(10進数)

    -- 透過した結果(10進数)
    local result_dec = math.floor(alpha * bg_dec + (1 - alpha) * target_dec)
    -- カラーコード
    result_color = result_color .. string.format("%02X", result_dec)
  end

  return result_color
end

---
-- 色名をカラーコードに変換
-- NOTE: builtinにあるような気もするけど見つけられなかったので一旦これを使う
--
-- @param string colorname
-- @return string colorcode
function M.get_colorcode_by_colorname(colorname)
  local colornames = {
    Black        = "#000000",
    DarkBlue     = "#00008B",
    DarkGreen    = "#006400",
    DarkCyan     = "#008B8B",
    DarkRed      = "#8B0000",
    DarkMagenta  = "#8B008B",
    Brown        = "#A52A2A",
    DarkYellow   = "#A9A900",
    LightGray    = "#D3D3D3",
    LightGrey    = "#D3D3D3",
    Gray         = "#808080",
    Grey         = "#808080",
    DarkGray     = "#A9A9A9",
    DarkGrey     = "#A9A9A9",
    Blue         = "#0000FF",
    LightBlue    = "#ADD8E6",
    Green        = "#00FF00",
    LightGreen   = "#90EE90",
    Cyan         = "#00FFFF",
    LightCyan    = "#E0FFFF",
    Red          = "#FF0000",
    LightRed     = "#FFA07A",
    Magenta      = "#FF00FF",
    LightMagenta = "#FF00FF",
    Yellow       = "#FFFF00",
    LightYellow  = "#FFFFE0",
    White        = "#FFFFFF"
  }

  return colornames[colorname]
end

--
-- background colorを取得する
--
function M.get_background()
  -- guibg の値を取得
  local bg_color = M.get_highlight_color('Normal', 'guibg')
  -- guibgが無しの場合は定数の値を使用
  if bg_color == nil then
    bg_color = vim.g["my#const"].term_bgcolor
  end
  return bg_color
end

--
-- highlight colorを取得する
-- NOTE: linkには対応していない...
--
function M.get_highlight_color(highlight_group, highlight_arg)
  local cmd_output = vim.fn.execute('hi ' .. highlight_group)
  local is_reverse = string.match(cmd_output, "reverse")
  local color

  if is_reverse and (highlight_arg == 'guifg' or highlight_arg == 'guibg') then
    -- `reverse` が適用されている場合、前景色と背景色を入れ替えて取得
    local fg_color = string.match(cmd_output, "guifg=(#%x+)")
    local bg_color = string.match(cmd_output, "guibg=(#%x+)")

    if highlight_arg == 'guifg' then
      color = bg_color -- 背景色を返す
    elseif highlight_arg == 'guibg' then
      color = fg_color -- 前景色を返す
    end
  else
    -- `reverse` が適用されていない場合、通常の方法で色を取得
    color = string.match(cmd_output, highlight_arg .. "=(#%x+)")
  end

  if color ~= "" then
    return color
  else
    return nil
  end
end

-------------------------------------------------------------------------------
-- setting highlight
-------------------------------------------------------------------------------
--
-- 差分系
--
function M.hi_diff(bg_color)
  -- 追加された行
  hi(0, 'DiffAdd', {
    bg = M.transparent_color(bg_color, "Green", 0.80)
  })
  -- 変更行
  hi(0, 'DiffChange', {
    bg = M.transparent_color(bg_color, "Yellow", 0.85)
  })
  -- 削除された行
  hi(0, 'DiffDelete', {
    bg = M.transparent_color(bg_color, "Red", 0.85)
  })
  -- 変更行の変更箇所
  hi(0, 'DiffText', {
    bg = M.transparent_color(bg_color, "#FD7E00", 0.40)
  })
end

--
-- 差分系(そのカラースキームで元々定義されている色を使用して再定義)
--
function M.hi_diff_by_own_colors(bg_color)
  -- 追加された行
  hi(0, 'DiffAdd', {
    bg = M.transparent_color(bg_color, M.get_highlight_color('DiffAdd', 'guibg'), 0.85)
  })
  -- 変更行
  hi(0, 'DiffChange', {
    bg = M.transparent_color(bg_color, M.get_highlight_color('DiffChange', 'guibg'), 0.85)
  })
  -- 削除された行
  hi(0, 'DiffDelete', {
    bg = M.transparent_color(bg_color, M.get_highlight_color('DiffDelete', 'guibg'), 0.85)
  })
  -- 変更行の変更箇所
  hi(0, 'DiffText', {
    bg = M.transparent_color(bg_color, M.get_highlight_color('DiffText', 'guibg'), 0.60)
  })
end

--
-- 検索系
--
function M.hi_search(bg_color)
  hi(0, 'CurSearch', {
    reverse = true,
    fg = "#FABD2F",
    bg = "#282828",
  })
  hi(0, 'IncSearch', {
    bg = M.transparent_color(bg_color, "#FABD2F", 0.60),
  })
  hi(0, 'Search', { link = "IncSearch" })
end

--
-- coc.nvimで使用するやつ
--
function M.hi_coc_colors(bg_color)
  hi(0, 'CocFadeOut', {
    bg = M.transparent_color(bg_color, "#ADABAC", 0.60),
    fg = "DarkGray"
  })
  hi(0, 'CocHintSign', { fg = "LightGrey" })
  hi(0, 'CocHighlightText', {
    bg = M.transparent_color(bg_color, "LightGrey", 0.75),
  })
end

--
-- ヤンク範囲
--
function M.hi_yank_region(bg_color)
  hi(0, 'HighlightedyankRegion', {
    bg = M.transparent_color(bg_color, "Magenta", 0.65),
  })
end

--
-- vim-matchup
--
function M.hi_matchup(bg_color)
  hi(0, 'MatchParen', {
    bg = M.transparent_color(bg_color, "LightGrey", 0.75),
    bold = true,
    underline = false
  })
  hi(0, 'MatchWord', { link = "MatchParen" })
  hi(0, 'MatchWordCur', { link = "MatchParen" })
end

--
-- gitsigns
--
function M.hi_gitsigns()
  -- gitsigns.nvim
  hi(0, 'GitSignsCurrentLineBlame', { link = "comment" })
  hi(0, 'GitSignsAdd', { fg = "LightGreen" })
  hi(0, 'GitSignsChange', { fg = "Yellow" })
  hi(0, 'GitSignsDelete', { fg = "Red" })
end

--
-- telescope
--
function M.hi_telescope()
  hi(0, 'TelescopePromptCounter', { link = "Comment" })
end

--
-- とりあえずこれつけとけばOK的なやつ
-- 特別何か固有の設定をしたい場合以外大体これ呼んどけばOK
--
function M.set_customcolor_common(bg_color)
  -- bg_colorが渡されなかったら取得する
  if not bg_color then
    bg_color = M.get_background()
  end

  -- 差分系
  M.hi_diff(bg_color)
  -- 検索系
  M.hi_search(bg_color)
  -- ヤンク範囲
  M.hi_yank_region(bg_color)
  -- coc.nvim用
  M.hi_coc_colors(bg_color)
  -- vim-matchup用
  M.hi_matchup(bg_color)
  -- gitsigns用
  M.hi_gitsigns()
  -- telescope用
  M.hi_telescope()
end

return M
