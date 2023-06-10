-- ================================================================================
-- Git
-- ================================================================================
local M = {}
--
-- diffview.nvim
--
M.lua_source_diffview = function()
  -- NOTE: マウスでスクロールする時は、差分の右側をスクロールしないとスクロールが同期されない
  -- TODO: 差分をdiscardする時、confirmするようにする
  require('diffview').setup ({
    enhanced_diff_hl = true,
    file_panel = {
      win_config = { -- diffviewのwindowの設定
        type = "split",
        position = "right",
        width = 40,
      },
    },
  })
end

return M
