-- ================================================================================
-- Git
-- ================================================================================
local g = vim.g
local fn = vim.fn

local M = {}

--
-- vim-fugitive
--
function M.lua_add_fugitive()
  vim.keymap.set('n', '<leader>gc', "<Cmd>Git commit<CR>", {})
  vim.keymap.set('n', '<leader>gp', "<Cmd>Git push<CR>", {})
end

--
-- diffview.nvim
--
function M.lua_source_diffview()
  -- NOTE: マウスでスクロールする時は、差分の右側をスクロールしないとスクロールが同期されない
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
  })
end

--
-- blamer.nvim
--
function M.lua_add_blamer()
  -- 日時のフォーマット
  g.blamer_date_format = '%Y/%m/%d %H:%M'
  -- ビジュアルモード時はオフ
  g.blamer_show_in_visual_modes = 0

  fn.timer_start(500,
    function()
      if not fn["utils#is_git_project"] then
        return
      end
      vim.cmd([[silent BlamerShow]])
    end
  )
end

--
-- gitsigns.nvim
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
    current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts      = {
      virt_text         = true,
      virt_text_pos     = 'eol', -- 'eol' | 'overlay' | 'right_align'
      delay             = 1000,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
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

return M
