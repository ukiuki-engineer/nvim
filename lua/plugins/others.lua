-- ================================================================================
-- Others
-- ================================================================================
local M = {}
--
-- nvim-treesitter
--
M.lua_source_treesitter = function()
  -- NOTE: 逆にデフォルトの方が見やすい場合はtreesitterを適宜オフに設定する
  require('nvim-treesitter.configs').setup {
    highlight = {
      enable = true, -- syntax highlightを有効にする
      disable = {    -- デフォルトの方が見やすい場合は無効に
      }
    },
    indent = {
      enable = true
    },
    matchup = {
      -- enable = true,              -- mandatory, false will disable the whole extension
      -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
    },
    context_commentstring = {
      enable = true,
    },
    ensure_installed = 'all', -- :TSInstall allと同じ
  }
  -- FIXME: 全部書かずに、追加分だけ書く事はできないのか？
  require("vim.treesitter.query").set(
    "markdown",
    "highlights",
    [[
      ;From nvim-treesitter/nvim-treesitter
      (atx_heading (inline) @text.title)
      (setext_heading (paragraph) @text.title)

      [
        (atx_h1_marker)
        (atx_h2_marker)
        (atx_h3_marker)
        (atx_h4_marker)
        (atx_h5_marker)
        (atx_h6_marker)
        (setext_h1_underline)
        (setext_h2_underline)
      ] @punctuation.special

      [
        (link_title)
        (indented_code_block)
        (fenced_code_block)
      ] @text.literal

      [
        (fenced_code_block_delimiter)
      ] @punctuation.delimiter

      (code_fence_content) @none

      [
        (link_destination)
      ] @text.uri

      [
        (link_label)
      ] @text.reference

      [
        (list_marker_plus)
        (list_marker_minus)
        (list_marker_star)
        (list_marker_dot)
        (list_marker_parenthesis)
        (thematic_break)
      ] @punctuation.special

      [
        (block_continuation)
        (block_quote_marker)
      ] @punctuation.special

      [
        (backslash_escape)
      ] @string.escape
      ; 引用はコメントと同じ色に
      (block_quote) @comment
    ]]
  )
end

--
-- telescope.nvim
--
M.lua_add_telescope = function()
  -- NOTE: on_cmdで遅延ロードさせるためにこういう回りくどいやり方をしている…
  vim.keymap.set('n', '<space>b', "<Cmd>Buffers<CR>", {})
  vim.keymap.set('n', '<space>f', "<Cmd>FindFiles<CR>", {})
  vim.keymap.set('n', '<space>g', "<Cmd>LiveGrep<CR>", {})
end

M.lua_source_telescope = function()
  vim.api.nvim_create_user_command('Buffers', "lua require('telescope.builtin').buffers()", {})
  vim.api.nvim_create_user_command(
    'FindFiles',
    [[lua require('telescope.builtin').find_files({
      find_command = {"rg", "--files", "--hidden", "--follow", "--glob", "!**/.git/*"}
    })]],
    {}
  )
  vim.api.nvim_create_user_command('CommandHistories', "lua require('telescope.builtin').command_history()", {})
  vim.api.nvim_create_user_command('Commands', "lua require('telescope.builtin').commands()", {})
  vim.api.nvim_create_user_command('GitBranches', "lua require('telescope.builtin').git_branches()", {})
  vim.api.nvim_create_user_command('GitStatus', "lua require('telescope.builtin').git_status()", {})
  vim.api.nvim_create_user_command('GrepCurrentBuffer', "lua require('telescope.builtin').current_buffer_fuzzy_find()", {})
  vim.api.nvim_create_user_command('HelpTags', "lua require('telescope.builtin').help_tags()", {})
  vim.api.nvim_create_user_command('LiveGrep', "lua require('telescope.builtin').live_grep()", {})
  vim.api.nvim_create_user_command('OldFiles', "lua require('telescope.builtin').oldfiles()", {})

  require('telescope').setup({
    defaults = {
      layout_config = {
        height = 0.90,
        width  = 0.95
      },
      mappings = {
        i = {
          ["<C-j>"] = function()
            vim.cmd([[call skkeleton#handle('toggle', {})]])
          end,
          -- NOTE: <C-/>でkeymapのhelpを表示
          -- ["<C-/>"] = "which_key",
        },
      },

    },
    -- pickers = {},
    extensions = {
      fzf = {
        fuzzy = true,                    -- false will only do exact matching
        override_generic_sorter = false, -- override the generic sorter
        override_file_sorter = true,     -- override the file sorter
        case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                         -- the default case_mode is "smart_case"
      }
    }
  })
  require('telescope').load_extension('fzf')
end

--
-- toggleterm.nvim
--
M.lua_source_toggleterm = function()
  require("toggleterm").setup{
    persist_size = false
  }
end

return M
