---
-- 共通処理
-- luaで書いた共通処理はここに集める
---
local M = {}

---
-- 透過色を計算する関数
-- @param string bg_color 背景色のカラーコード(16進数)。例: "#FFFFFF"
-- @param string target_color 対象色のカラーコード(16進数)。例: "#000000"
-- @param number alpha 透過率。0から1の値で指定する。0に近いほど背景色が優先され、1に近いほど対象色が優先される。
-- @return string 透過させた色のカラーコード(16進数)。例: "#808080"
function M.transparent_color(bg_color, target_color, alpha)
  -- target_colorにcolornameが指定されている場合、colorcodeに変換
  if string.sub(target_color, 1, 1) ~= "#" then
    target_color = M.get_colorcode_by_colorname(target_color)
  end

  if string.sub(target_color, 1, 1) ~= "#"  and (not target_color or target_color == "") then
    return ''
  end

  local result_color = "#"

  -- 背景色と対象色を10進数に変換して、透過させた色を計算
  for i = 1, 3 do -- R, G, Bごとに処理
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
-- @param string colorname
-- @return string colorcode
-- NOTE: vim内の関数であるような気もするけど見つけられなかったので一旦これを使う
function M.get_colorcode_by_colorname(colorname)
  local colornames = {
    ["Black"]        = "#000000",
    ["DarkBlue"]     = "#00008B",
    ["DarkGreen"]    = "#006400",
    ["DarkCyan"]     = "#008B8B",
    ["DarkRed"]      = "#8B0000",
    ["DarkMagenta"]  = "#8B008B",
    ["Brown"]        = "#A52A2A",
    ["DarkYellow"]   = "#A9A900",
    ["LightGrey"]    = "#D3D3D3",
    ["Grey"]         = "#808080",
    ["DarkGrey"]     = "#A9A9A9",
    ["Blue"]         = "#0000FF",
    ["LightBlue"]    = "#ADD8E6",
    ["Green"]        = "#00FF00",
    ["LightGreen"]   = "#90EE90",
    ["Cyan"]         = "#00FFFF",
    ["LightCyan"]    = "#E0FFFF",
    ["Red"]          = "#FF0000",
    ["LightRed"]     = "#FFA07A",
    ["Magenta"]      = "#FF00FF",
    ["LightMagenta"] = "#FF00FF",
    ["Yellow"]       = "#FFFF00",
    ["LightYellow"]  = "#FFFFE0",
    ["White"]        = "#FFFFFF"
  }

  return colornames[colorname]
end

function M.map_zenkaku(hankaku_zenkaku_pairs)
  for hankaku, zenkaku in pairs(hankaku_zenkaku_pairs) do
    vim.keymap.set('n', '<leader>f' .. hankaku, 'f' .. zenkaku, {})
    vim.keymap.set('n', '<leader>t' .. hankaku, 't' .. zenkaku, {})
    vim.keymap.set('n', '<leader>df' .. hankaku, 'df' .. zenkaku, {})
    vim.keymap.set('n', '<leader>dt' .. hankaku, 'dt' .. zenkaku, {})
    vim.keymap.set('n', '<leader>yf' .. hankaku, 'yf' .. zenkaku, {})
    vim.keymap.set('n', '<leader>yt' .. hankaku, 'yt' .. zenkaku, {})
  end
end

return M
