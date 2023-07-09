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
  -- Highlight the @foo.bar capture group with the "Identifier" highlight group
  -- vim.api.nvim_set_hl(0, "@foo.bar", { link = "Identifier" })
  -- Highlight @foo.bar as "Identifier" only in Lua files
  -- vim.api.nvim_set_hl(0, "@foo.bar.lua", { link = "Identifier" })
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
-- NOTE: on_cmdで遅延ロードさせるためにこういう回りくどいやり方をしている…
--
M.lua_add_telescope = function()
  vim.keymap.set('n', '<space>af', "<Cmd>FindAllFiles<CR>", {})
  vim.keymap.set('n', '<space>b', "<Cmd>Buffers<CR>", {})
  vim.keymap.set('n', '<space>f', "<Cmd>FindFiles<CR>", {})
  vim.keymap.set('n', '<space>g', "<Cmd>LiveGrep<CR>", {})
end

M.lua_source_telescope = function()
  vim.api.nvim_create_user_command('Buffers', "lua require('telescope.builtin').buffers()", {})
  vim.api.nvim_create_user_command('FindAllFiles', [[lua require('telescope.builtin').find_files({
    hidden = true,
    no_ignore = true,
  })]], {})
  vim.api.nvim_create_user_command('FindFiles', "lua require('telescope.builtin').find_files()", {})
  vim.api.nvim_create_user_command('GitStatus', "lua require('telescope.builtin').git_status()", {})
  vim.api.nvim_create_user_command('GrepCurrentBuffer', "lua require('telescope.builtin').current_buffer_fuzzy_find()", {})
  vim.api.nvim_create_user_command('HelpTags', "lua require('telescope.builtin').help_tags()", {})
  vim.api.nvim_create_user_command('LiveGrep', "lua require('telescope.builtin').live_grep()", {})

  require('telescope').setup({
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = function()
            vim.cmd([[call skkeleton#handle('toggle', {})]])
          end
        }
      }
    },
    -- pickers = {},
    -- extensions = {}
  })
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
