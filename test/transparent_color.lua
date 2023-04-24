---
-- 透過色処理のテスト
---

-- NOTE: 設定ファイル中で呼ぶ時は、`lua/`は省略可
local my_functions = require("lua/my_functions")

local bg_color     = "#FFFFFF"     -- 白色
local target_color = "#0000FF" -- 青色

-- NOTE: 6行目を省略して、以下のように呼び出しても良い
-- require("lua/my_functions.lua").transparent_color(bg_color, target_color, alpha)

print("bg_color     = " .. bg_color)
print("target_color = " .. target_color)
print("")
print("透過率1の場合   -> " .. my_functions.transparent_color(bg_color, target_color, 1))
print("透過率0の場合   -> " .. my_functions.transparent_color(bg_color, target_color, 0))
print("透過率0.5の場合 -> " .. my_functions.transparent_color(bg_color, target_color, 0.5))
