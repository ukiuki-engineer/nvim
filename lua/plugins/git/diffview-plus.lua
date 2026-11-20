local M = {}

-- diffview.luaを複製し、従来の見た目・操作を維持する設定
function M.lua_source()
  -- NOTE: luaで書くと上手くいかないのでvimscriptで
  vim.cmd([[
    augroup MyDiffviewAuCmds
      au!
      " git情報を更新（スクリプトローカル関数を介さず直接呼ぶ）
      au User DiffviewViewOpened call utils#git_info#async_refresh_git_infomation()
      au ColorScheme * highlight! link DiffviewCommitSelected DiffviewFilePanelSelected
    augroup END

    " 履歴の選択中コミットも従来と同じ色にする
    highlight! link DiffviewCommitSelected DiffviewFilePanelSelected
  ]])

  -- 手動で再設定する既存コマンドを維持する
  -- TODO: diffviewではkeymapが反映されたりされなかったり不安定だったから
  -- 苦肉の策としてこのコマンドを定義してたけど、ここでは不要かも
  vim.api.nvim_create_user_command('ResettingDiffview', function()
    vim.cmd([[DiffviewClose]])
    M.diffview_setup()
    vim.cmd([[DiffviewOpen]])
  end, {})

  -- diffview-plus.nvimの設定を実行
  M.diffview_setup()
end

-- diffview-plus.nvimの設定（コマンド名・Luaモジュール名はdiffviewのまま）
function M.diffview_setup()
  require('diffview').setup({
    enhanced_diff_hl = true,
    -- 従来どおり、Diffviewのタブをセッションから自動復元しない
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
      -- 従来と同じ数値表示・色分け・日付の自動切替を維持する
      stat_style = "number",
      subject_highlight = "plain",
      date_format = "auto", -- 常に絶対日付にする場合は "iso"
    },
    keymaps = {
      file_panel = {
        -- デフォルトと同じ小文字表記にし、矢印キーの重複定義を防ぐ
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
