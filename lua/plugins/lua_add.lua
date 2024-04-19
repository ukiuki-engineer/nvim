--------------------------------------------------------------------------------
-- NOTE: vim起動時に不要なrequire()を減らすために、
--       lua_addで呼びだす処理は全部ここに集める
--------------------------------------------------------------------------------

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
      au User GinCommandPost,GinComponentPost call git_info#refresh_git_infomation()
    augroup END
  ]])

  -- commands
  vim.api.nvim_create_user_command('DeleteLatestCommit',
    function() require("plugins.git.gin").pcall_delete_latest_commit('soft') end, {})
  vim.api.nvim_create_user_command('GinPush', require("plugins.git.gin").pcall_git_push_confirm, {})
  -- TODO: 引数を渡せるようにする。↓みたいな感じでいけるらしい。
  -- vim.cmd("command! -nargs=? GinPush call luaeval('M.pcall_git_push_confirm(_A)', <q-args>)")
end

function M.diffview()
  vim.keymap.set('n', '<Right>', function()
    vim.fn['git_info#refresh_git_infomation'](true)
    vim.cmd([[DiffviewOpen]])
  end, {})
  vim.keymap.set('n', '<Down>', "<Cmd>DiffviewFileHistory<CR>", {})
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
end

function M.oil()
  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
end

return M
