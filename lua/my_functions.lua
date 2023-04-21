---
-- 共通処理
-- luaで書いた共通処理はここに集める
---
local M = {}

---
-- 透過色を計算する関数
-- @param bg_color string 背景色のカラーコード(16進数)。例: "#FFFFFF"
-- @param target_color string 対象色のカラーコード(16進数)。例: "#000000"
-- @param alpha number 透過率。0から1の値で指定する。0に近いほど背景色が優先され、1に近いほど対象色が優先される。
-- @return string 透過させた色のカラーコード(16進数)。例: "#808080"
M.transparent_color = function(bg_color, target_color, alpha)
  local result_color = "#"

  -- 背景色と対象色を10進数に変換して、透過させた色を計算
  for i = 1, 3 do -- R, G, Bごとに処理
    bg_hex = string.sub(bg_color, i * 2, (i * 2) + 1)         -- 背景(16進数)
    bg_dec = tonumber(bg_hex, 16)                             -- 背景(10進数)
    target_hex = string.sub(target_color, i * 2, (i * 2) + 1) -- 対象(16進数)
    target_dec = tonumber(target_hex, 16)                     -- 対象(10進数)

    -- 透過した結果(10進数)
    local result_dec = math.floor(alpha * bg_dec + (1 - alpha) * target_dec)
    -- カラーコード
    result_color = result_color .. string.format("%02X", result_dec)
  end

    return result_color
end

return M
