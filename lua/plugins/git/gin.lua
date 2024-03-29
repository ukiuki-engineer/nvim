-------------------------------------------------------------------------------
-- gin.vim
-------------------------------------------------------------------------------
-- confirmしてpushする
local function git_push_confirm()
  vim.fn['git_info#refresh_git_infomation']()

  local message = ""

  -- remote branchが無い場合の処理
  if not vim.g['git_info#git_info']['exists_remote_branch'] then
    message = 'There is no remote branch for the \"' ..
        vim.g['git_info#git_info']['branch_name'] .. '\". Would you like to publish this branch?'

    if vim.fn["utils#confirm"](message) then
      vim.cmd("Gin push --set-upstream origin HEAD")
    end
    return
  end

  -- commit数を取得
  local commit_counts = vim.g['git_info#git_info']['commit_counts']['un_pushed']
  commit_counts = tonumber(commit_counts)

  -- commitなしならメッセージを表示して終了
  if commit_counts == "" or commit_counts == 0 then
    print("No commits to push.")
    return
  end

  message = commit_counts == 1
      and "push " .. commit_counts .. " commit?"
      or "push " .. commit_counts .. " commits?"

  if vim.fn["utils#confirm"](message) then
    vim.cmd([[Gin push]])
  end
end

-- confirmしてgit resetする
local function delete_latest_commit(soft_or_hard)
  if not vim.fn["utils#confirm"]("Delete latest commit?") then
    return
  end
  vim.cmd("Gin ++wait reset --" .. soft_or_hard .. " HEAD^")
  vim.cmd([[DiffviewRefresh]])
end

--

local M = {}

function M.lua_add()
  -- 画面分割して開く
  vim.g.gin_proxy_editor_opener = 'split'

  vim.cmd([[
    augroup MyGinAuCmds
      au!
      au User GinCommandPost,GinComponentPost call git_info#refresh_git_infomation()
    augroup END
  ]])

  -- commands
  vim.api.nvim_create_user_command('DeleteLatestCommit', function() M.pcall_delete_latest_commit('soft') end, {})
  vim.api.nvim_create_user_command('GinPush', M.pcall_git_push_confirm, {})
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
