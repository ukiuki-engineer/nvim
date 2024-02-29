--
-- gin.vim
--
local g       = vim.g
local fn      = vim.fn
local command = vim.api.nvim_create_user_command

-- confirmしてpushする
local function git_push_confirm()
  vim.fn['utils#refresh_git_infomations']()

  local message = ""

  -- remote branchが無い場合の処理
  if not g['my#git_info']['exists_remote_branch'] then
    message = 'There is no remote branch for the \"' ..
        g['my#git_info']['branch_name'] .. '\". Would you like to publish this branch?'

    if vim.fn["utils#confirm"](message) then
      vim.cmd("Gin push --set-upstream origin HEAD")
    end
    return
  end

  local commit_count = g['my#git_info']['commit_count']['local']
  commit_count = tonumber(commit_count)

  if commit_count == "" or commit_count == 0 then
    print("no commits")
    return
  end

  message = commit_count == 1
      and "push " .. commit_count .. " commit?"
      or "push " .. commit_count .. "commits?"

  if vim.fn["utils#confirm"](message) then
    vim.cmd([[Gin push]])
  end
end

-- confirmしてgit resetする
local function delete_latest_commit(soft_or_hard)
  if not vim.fn["utils#confirm"]("Delete latest commit?") then
    return
  end
  vim.cmd("Gin reset --" .. soft_or_hard .. " HEAD^")
  -- NOTE: 普通にcommand実行するだけだとなんか時々上手くいかないのでtimer遅延をかける
  fn.timer_start(1000,
    function()
      -- diffviewをrefresh
      vim.cmd([[DiffviewRefresh]])
    end
  )
end

--

local M = {}

function M.lua_add()
  -- 画面分割して開く
  g.gin_proxy_editor_opener = 'split'

  vim.cmd([[
    augroup MyGinAuCmds
      au!
      au User GinCommandPost call utils#refresh_git_infomations()
      au User GinComponentPost call utils#refresh_git_infomations()
    augroup END
  ]])

  -- commands
  command('DeleteLatestCommit', function() M.pcall_delete_latest_commit('soft') end, {})
  command('GinPush', M.pcall_git_push_confirm, {})
  -- TODO: 引数を渡せるようにする。↓みたいな感じでいけるらしい。
  -- vim.cmd("command! -nargs=? GinPush call luaeval('M.pcall_git_push_confirm(_A)', <q-args>)")
end

--------------------------------------------------------------------------------
-- プラグイン設定以外で外部に公開するfunctions
--------------------------------------------------------------------------------
-- git_push_confirm()をpcallでラップして実行
function M.pcall_git_push_confirm()
  local success, exception = pcall(git_push_confirm)
  if not success then
    require("utils").echo_error_message("E006", exception)
  end
end

-- delete_latest_commit()をpcallでラップして実行
function M.pcall_delete_latest_commit(soft_or_hard)
  local success, exception = pcall(delete_latest_commit, soft_or_hard)
  if not success then
    require("utils").echo_error_message("E007", exception)
  end
end

return M
