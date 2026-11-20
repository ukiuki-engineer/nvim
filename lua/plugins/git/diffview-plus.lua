local M = {}

-- NOTE: diffview.luaを複製してから作成した
function M.lua_source()
  -- NOTE: luaで書くと上手くいかないのでvimscriptで
  vim.cmd([[
    augroup MyDiffviewAuCmds
      au!
      " git情報を更新
      au User DiffviewViewOpened call utils#git_info#async_refresh_git_infomation()
      au ColorScheme * highlight! link DiffviewCommitSelected DiffviewFilePanelSelected
    augroup END

    " 履歴の選択中コミットも従来と同じ色にする
    highlight! link DiffviewCommitSelected DiffviewFilePanelSelected
  ]])

  -- diffview-plus.nvimの設定を実行
  M.diffview_setup()
end

-- diffview-plus.nvimの設定（コマンド名・Luaモジュール名はdiffviewのまま）
function M.diffview_setup()
  require('diffview').setup({
    enhanced_diff_hl = true,
    -- Diffviewのタブをセッションから自動復元しない
    restore_session = false,
    view = {
      merge_tool = {
        layout = "diff3_mixed"
      }
    },
    file_panel = {
      listing_style = "list",
      win_config = {
        -- diffviewのwindowの設定
        type = "split",
        position = "right",
        width = 40,
      },
    },
    file_history_panel = {
      stat_style = "number",
      subject_highlight = "plain",
      date_format = "iso", -- 常に年月日・時刻・タイムゾーンを表示する
    },
    keymaps = {
      file_panel = {
        -- NOTE: 矢印キーを先頭大文字表記にすると挙動が不安定になる？？
        -- commit
        { "n", "<down>",
          function()
            vim.cmd([[Gin commit]])
          end,
          { desc = "execute :Gin commit" }
        },
        -- confirmしてpushする
        { "n", "<up>",
          function()
            require("plugins.lua_add").pcall_git_push_confirm()
          end,
          { desc = "confirm -> :Gin push" }
        },
        -- confirmして変更を削除する
        { "n", "X",
          function()
            local message = "Delete this changes?"
            if not vim.fn["utils#utils#confirm"](message) then
              return
            end
            -- restore
            require("diffview.actions").restore_entry()
            -- git情報を更新
            vim.fn["utils#git_info#async_refresh_git_infomation"]()
          end,
          { desc = "confirm -> restore" }
        },
      }
    }
  })
end

return M
