---
-- 透過色処理のテスト
---

-- NOTE: 設定ファイル中で呼ぶ時は、`lua/`は省略可
local my_functions = require("lua/my_functions")

-- local bg_color = "#FFFFFF"     -- 白色
-- local target_color = "#0000FF" -- 青色
-- local alpha = 0.5              -- 透過率
local bg_color = "#1C1C1C"
local target_color = "#ADABAC"
local alpha = 0.8

local result_color = my_functions.transparent_color(bg_color, target_color, alpha)
print(result_color)
