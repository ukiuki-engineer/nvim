local M = {}

function M.lua_source()
  -- NOTE: luaで書くと上手くいかないのでvimscriptで
  vim.cmd([[
    " 表示スタイル(tree/list)をtoggle & git情報を更新
    function! s:aucmds_on_diffviewopen() abort
      " git情報を更新
      call utils#git_info#async_refresh_git_infomation()
    endfunction

    augroup MyDiffviewAuCmds
      au!
      " diffviewのopen時に実行
      au User DiffviewViewOpened call s:aucmds_on_diffviewopen()
    augroup END
  ]])

  -- diffview.nvimを再設定するコマンド
  -- NOTE: keymappingが効かない時用。設定し直して開き直す。(何故かMacだけkeymappingが効かない時がある)
  vim.api.nvim_create_user_command('ResettingDiffview', function()
    vim.cmd([[DiffviewClose]])
    M.diffview_setup()
    vim.cmd([[DiffviewOpen]])
  end, {})

  -- diffview.nvimの設定を実行
  M.diffview_setup()
end

-- diffview.nvimの設定
function M.diffview_setup()
  require('diffview').setup({
    enhanced_diff_hl = true,
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
    keymaps = {
      file_panel = {
        -- TODO: 何故か効いたり効かなかったりする {{{
        -- commit
        { "n", "<Down>",
          function()
            vim.cmd([[Gin commit]])
          end,
          { desc = "execute :Gin commit" }
        },
        -- confirmしてpushする
        { "n", "<Up>",
          function()
            require("plugins.lua_add").pcall_git_push_confirm()
          end,
          { desc = "confirm -> :Gin push" }
        },
        -- }}}
        -- confirmして変更を削除する
        { "n", "X",
          function()
            local message = "Delete this changes?"
            if not vim.fn["utils#utils#confirm"](message) then
              return
            end
            -- restore
            require("diffview.config").actions.restore_entry()
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
