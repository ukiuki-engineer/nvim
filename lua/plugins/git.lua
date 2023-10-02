-- ================================================================================
-- Git
-- ================================================================================
local g       = vim.g
local fn      = vim.fn
local command = vim.api.nvim_create_user_command

-- confirmしてpushする
local function git_push_confirm()
  vim.fn['utils#refresh_git_infomations']()

  local message = ""

  -- remote branchが無い場合の処理
  if not g['my#git_infomations']['exists_remote_branch'] then
    message = 'There is no remote branch for the \"' ..
        g['my#git_infomations']['branch_name'] .. '\". Would you like to publish this branch?'

    if vim.fn["utils#confirm"](message) then
      vim.cmd("Gin push origin " .. g['my#git_infomations']['branch_name'])
    end
    return
  end

  local commit_count = g['my#git_infomations']['commit_count']['local']
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

local M = {}

--
-- gin.vim
--
function M.lua_add_gin()
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
end

--
-- diffview.nvim
--
function M.lua_add_diffview()
  vim.keymap.set('n', '<Right>', "<Cmd>DiffviewOpen<CR>", {})
  vim.keymap.set('n', '<Down>', "<Cmd>DiffviewFileHistory<CR>", {})

  -- NOTE: keymappingが効かない時用。設定し直して開き直す。
  command('ResettingDiffview', function()
    vim.cmd([[DiffviewClose]])
    M.lua_source_diffview()
    vim.cmd([[DiffviewOpen]])
  end, {})
end

function M.lua_source_diffview()
  -- NOTE: luaで書くと上手くいかないのでvimscriptで
  vim.cmd([[
    " 表示スタイル(tree/list)をtoggle & git情報を更新
    function! s:aucmds_on_diffviewopen() abort
      lua require("diffview.config").actions.listing_style()
      call utils#refresh_git_infomations()
    endfunction

    augroup MyDiffviewAuCmds
      au!
      au User DiffviewViewOpened call s:aucmds_on_diffviewopen()
    augroup END
  ]])

  require('diffview').setup({
    enhanced_diff_hl = true,
    file_panel = {
      win_config = {
        -- diffviewのwindowの設定
        type = "split",
        position = "right",
        width = 40,
      },
    },
    keymaps = {
      file_panel = {
        -- 効いたり効かなかったりする {{{
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
            M.pcall_git_push_confirm()
          end,
          { desc = "confirm -> :Gin push" }
        },
        -- }}}
        -- confirmして変更を削除する
        { "n", "X",
          function()
            local message = "Delete this changes?"
            if not vim.fn["utils#confirm"](message) then
              return
            end
            -- restore
            require("diffview.config").actions.restore_entry()
            -- git情報を更新
            vim.fn["utils#refresh_git_infomations"]()
          end,
          { desc = "confirm -> restore" }
        },
        -- TODO: stage, unstage等も全部ラップし、refreshを噛ませる
      }
    }
  })
end

--
-- gitsigns.nvim
-- FIXME: cocのdiagnosticsが被ってgitsignsが見えなくなるのをどうにかできないか？
-- TODO: stageした行もそれが分るように表示できないか？
--
function M.lua_source_gitsigns()
  require('gitsigns').setup({
    -- settings
    signs                        = {
      -- add          = { text = '│' },
      add          = { text = '+' },
      -- change       = { text = '│' },
      change       = { text = '~' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir                 = {
      follow_files = true
    },
    attach_to_untracked          = true,
    current_line_blame           = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts      = {
      virt_text         = true,
      virt_text_pos     = 'eol', -- 'eol' | 'overlay' | 'right_align'
      delay             = 1000,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = ' <author>, <author_time:%Y/%m/%d> - <summary>',
    sign_priority                = 6,
    update_debounce              = 100,
    status_formatter             = nil,   -- Use default
    max_file_length              = 40000, -- Disable if file is longer than this (in lines)
    preview_config               = {
      -- Options passed to nvim_open_win
      border   = 'single',
      style    = 'minimal',
      relative = 'cursor',
      row      = 0,
      col      = 1
    },
    yadm                         = {
      enable = false
    },

    -- keymaps
    on_attach                    = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map({ 'n', 'x' }, ']c', function() -- 次のgit差分にジャンプ
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, { expr = true })

      map({ 'n', 'x' }, '[c', function() -- 前のgit差分にジャンプ
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, { expr = true })

      -- Actions
      -- NOTE: この辺はコマンド定義しても良いかも
      map('n', '<leader>hs', gs.stage_hunk)
      map('n', '<leader>hr', gs.reset_hunk)
      map('x', '<leader>hs', function() gs.stage_hunk { fn.line('.'), fn.line('v') } end)
      map('x', '<leader>hr', function() gs.reset_hunk { fn.line('.'), fn.line('v') } end)
      map('n', '<leader>hS', gs.stage_buffer)
      map('n', '<leader>hu', gs.undo_stage_hunk)
      map('n', '<leader>hR', gs.reset_buffer)
      map('n', '<leader>hp', gs.preview_hunk)
      map('n', '<leader>hb', function() gs.blame_line { full = true } end)
      map('n', '<leader>tb', gs.toggle_current_line_blame)
      map('n', '<leader>hd', gs.diffthis)
      map('n', '<leader>hD', function() gs.diffthis('~') end)
      map('n', '<leader>td', gs.toggle_deleted)

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end

  })
end

--------------------------------------------------------------------------------
-- functions
--------------------------------------------------------------------------------
-- TODO: pcall_execute()みたいに共通化した方が良いかも？

-- git_push_confirm()をpcallでラップして実行
function M.pcall_git_push_confirm()
  local success, error_message = pcall(git_push_confirm)
  if not success then
    vim.api.nvim_echo(
      { { "An error occurred in plugins.git.git_push_confirm(): " .. error_message, "ErrorMsg" }, },
      true,
      {}
    )
  end
end

-- delete_latest_commit()をpcallでラップして実行
function M.pcall_delete_latest_commit(soft_or_hard)
  local success, error_message = pcall(delete_latest_commit, soft_or_hard)
  if not success then
    vim.api.nvim_echo(
      { { "An error occurred in plugins.git.delete_latest_commit(): " .. error_message, "ErrorMsg" }, },
      true,
      {}
    )
  end
end

return M
