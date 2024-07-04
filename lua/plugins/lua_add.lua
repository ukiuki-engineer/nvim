--------------------------------------------------------------------------------
-- NOTE: vim起動時に不要なrequire()を減らすために、
--       lua_addで呼びだす処理は全部ここに集める
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- local
--------------------------------------------------------------------------------
-- confirmしてpushする
local function _git_push_confirm()
  vim.fn['utils#git_info#refresh_git_infomation']()

  local message = ""

  -- remote branchが無い場合の処理
  if not vim.g['utils#git_info#git_info']['exists_remote_branch'] then
    message = 'There is no remote branch for the \"' ..
        vim.g['utils#git_info#git_info']['branch_name'] .. '\". Would you like to publish this branch?'

    if vim.fn["utils#utils#confirm"](message) then
      vim.cmd("Gin push --set-upstream origin HEAD")
    end
    return
  end

  -- commit数を取得
  local commit_counts = vim.g['utils#git_info#git_info']['commit_counts']['un_pushed']
  commit_counts = tonumber(commit_counts)

  -- commitなしならメッセージを表示して終了
  if commit_counts == "" or commit_counts == 0 then
    print("No commits to push.")
    return
  end

  message = commit_counts == 1
      and "push " .. commit_counts .. " commit?"
      or "push " .. commit_counts .. " commits?"

  if vim.fn["utils#utils#confirm"](message) then
    vim.cmd([[Gin push]])
  end
end

-- confirmしてgit resetする
local function _delete_latest_commit(soft_or_hard)
  if not vim.fn["utils#utils#confirm"]("Delete latest commit?") then
    return
  end
  vim.cmd("Gin ++wait reset --" .. soft_or_hard .. " HEAD^")
  vim.cmd([[DiffviewRefresh]])
end

local M = {}
--------------------------------------------------------------------------------
-- UI
--------------------------------------------------------------------------------

function M.timer_start_lualine(time)
  vim.fn.timer_start(
    time,
    function()
      require("plugins.ui.lualine").setup()
    end
  )
end

function M.timer_start_bufferline(time)
  vim.fn.timer_start(
    time,
    function()
      require("plugins.ui.bufferline").setup()
    end
  )
end

function M.timer_start_scrollbar(time)
  vim.fn.timer_start(
    time,
    function()
      require("plugins.ui.scrollbar").setup()
    end
  )
end

function M.nvim_tree()
  vim.keymap.set('n', '<C-n>', "<Cmd>NvimTreeToggle<CR>", {})
  vim.keymap.set('n', '<C-w>t', "<Cmd>NvimTreeFindFile<CR>", {})
end

--------------------------------------------------------------------------------
-- coding
--------------------------------------------------------------------------------
function M.codeium()
  vim.g.codeium_filetypes = {
    markdown = false,
    text     = false,
    csv      = false,
  }
  vim.g.codeium_no_map_tab = true

  vim.keymap.set('i', '<C-g>', function()
    return vim.fn['codeium#Accept']()
  end, { expr = true, silent = true })

  vim.keymap.set('i', '<c-;>', function()
    return vim.fn['codeium#CycleCompletions'](1)
  end, { expr = true, silent = true })

  vim.keymap.set('i', '<c-,>', function()
    return vim.fn['codeium#CycleCompletions'](-1)
  end, { expr = true, silent = true })

  vim.keymap.set('i', '<c-x>', function()
    return vim.fn['codeium#Clear']()
  end, { expr = true, silent = true })
end

--------------------------------------------------------------------------------
-- Git
--------------------------------------------------------------------------------
function M.gin()
  -- 画面分割して開く
  vim.g.gin_proxy_editor_opener = 'split'

  vim.cmd([[
    augroup MyGinAuCmds
      au!
      au User GinCommandPost,GinComponentPost call utils#git_info#refresh_git_infomation()
    augroup END
  ]])

  -- commands
  vim.api.nvim_create_user_command('DeleteLatestCommit',
    function() M.pcall_delete_latest_commit('soft') end, {})
  vim.api.nvim_create_user_command('GinPush', M.pcall_git_push_confirm, {})
  -- TODO: 引数を渡せるようにする。↓みたいな感じでいけるらしい。
  -- vim.cmd("command! -nargs=? GinPush call luaeval('M.pcall_git_push_confirm(_A)', <q-args>)")
end

function M.diffview()
  vim.keymap.set('n', '<Right>', function()
    if require("utils.utils").is_git_project() then
      vim.fn['utils#git_info#refresh_git_infomation'](true)
      vim.cmd([[DiffviewOpen]])
    end
  end, {})
  vim.keymap.set('n', '<Down>', function()
    if require("utils.utils").is_git_project() then
      vim.cmd([[DiffviewFileHistory]])
    end
  end, {})
end

--------------------------------------------------------------------------------
-- FZF
--------------------------------------------------------------------------------
function M.telescope()
  -- NOTE: on_cmdで遅延ロードさせるためにこういう回りくどいやり方をしている…
  vim.keymap.set('n', '<Left>', "<Cmd>GitStatus<CR>", {})
  vim.keymap.set('n', '<space>b', "<Cmd>Buffers<CR>", {})
  vim.keymap.set('n', '<space>c', "<Cmd>Commits<CR>", {})
  vim.keymap.set('n', '<space>f', "<Cmd>FindFiles<CR>", {})
  vim.keymap.set('n', '<space>g', "<Cmd>LiveGrep<CR>", {})
  vim.keymap.set('n', '<space>p', "<Cmd>FindFilesAll<CR>", {})
  vim.keymap.set('n', '<space>s', "<Cmd>GitStatus<CR>", {})
end

--------------------------------------------------------------------------------
-- LSP
--------------------------------------------------------------------------------
function M.coc()
  -- coc-extensions
  vim.g.coc_global_extensions = {
    '@yaegassy/coc-intelephense',
    '@yaegassy/coc-laravel',
    '@yaegassy/coc-marksman',
    'coc-blade',
    'coc-css',
    'coc-cssmodules',
    'coc-deno',
    'coc-docker',
    'coc-eslint',
    'coc-fzf-preview',
    'coc-html',
    'coc-jedi',
    'coc-json',
    'coc-lua',
    'coc-php-cs-fixer',
    'coc-prettier',
    'coc-sh',
    'coc-snippets',
    'coc-solargraph',
    'coc-spell-checker',
    'coc-sql',
    'coc-tsserver',
    'coc-vetur',
    'coc-vimlsp',
    'coc-word',
    'coc-xml',
    'coc-yaml',
  }
end

--------------------------------------------------------------------------------
-- Others
--------------------------------------------------------------------------------
function M.quickrun()
  local opts = { noremap = true, silent = true }
  vim.keymap.set({ "n", "x" }, "<F5>", ":QuickRun<CR>", opts)
  vim.keymap.set({ "n", "x" }, "<space>5", ":QuickRun<CR>", opts)
end

function M.oil()
  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
end

--------------------------------------------------------------------------------
-- プラグイン設定以外で外部に公開するfunctions
--------------------------------------------------------------------------------
-- _git_push_confirm()をpcallでラップして実行
function M.pcall_git_push_confirm()
  local success, exception = pcall(_git_push_confirm)
  if not success then
    require("utils.utils").echo_error_message("E006", exception)
  end
end

-- _delete_latest_commit()をpcallでラップして実行
function M.pcall_delete_latest_commit(soft_or_hard)
  local success, exception = pcall(_delete_latest_commit, soft_or_hard)
  if not success then
    require("utils.utils").echo_error_message("E007", exception)
  end
end

return M
