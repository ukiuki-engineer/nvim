-- ================================================================================
-- Others
-- ================================================================================
local M = {}
--
-- nvim-treesitter
--
function M.lua_source_treesitter()
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
function M.lua_add_telescope()
  -- NOTE: on_cmdで遅延ロードさせるためにこういう回りくどいやり方をしている…
  vim.keymap.set('n', '<space>b', "<Cmd>Buffers<CR>", {})
  vim.keymap.set('n', '<space>f', "<Cmd>FindFiles<CR>", {})
  vim.keymap.set('n', '<space>g', "<Cmd>LiveGrep<CR>", {})
end

function M.lua_source_telescope()
  vim.api.nvim_create_user_command('BufferLines', "lua require('telescope.builtin').current_buffer_fuzzy_find()", {})
  vim.api.nvim_create_user_command('Buffers', "lua require('plugins.others').buffers()", {})
  vim.api.nvim_create_user_command('CommandHistories', "lua require('telescope.builtin').command_history()", {})
  vim.api.nvim_create_user_command('Commands', "lua require('telescope.builtin').commands()", {})
  vim.api.nvim_create_user_command('Commits', "lua require('telescope.builtin').git_commits()", {})
  vim.api.nvim_create_user_command('FindFiles', "lua require('plugins.others').find_files()", {})
  vim.api.nvim_create_user_command('GitBranches', "lua require('telescope.builtin').git_branches()", {})
  vim.api.nvim_create_user_command('GitStatus', "lua require('plugins.others').git_status()", {})
  vim.api.nvim_create_user_command('HelpTags', "lua require('telescope.builtin').help_tags()", {})
  vim.api.nvim_create_user_command('OldFiles', "lua require('telescope.builtin').oldfiles()", {})

  vim.cmd([[command! -nargs=* LiveGrep :lua require("plugins.others").live_grep("<args>")]])
  -- NOTE: ↑の使用例:
  -- :LiveGrep *.toml

  require('telescope').setup({
    defaults = {
      layout_strategy = 'horizontal',
      layout_config = {
        height = 0.90,
        width  = 0.95,
        horizontal = {
          preview_width = 0.60
        },
      },
      mappings = {
        i = {
          ["<C-j>"] = function()
            vim.fn['skkeleton#handle']('toggle', {})
          end,
          -- NOTE: <C-/>でkeymapのhelpを表示
          -- ["<C-/>"] = "which_key",
        },
      },

    },
    pickers = {
      live_grep = {
        -- grepはResultを広く取りたいので水平分割
        layout_strategy = 'vertical',
      }
    },
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

function M.buffers()
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  -- 指定されたバッファを削除する
  local delete_buf = function(prompt_bufnr)
    local current_picker = action_state.get_current_picker(prompt_bufnr)
    local multi_selections = current_picker:get_multi_selection()

    if next(multi_selections) == nil then
      actions.delete_buffer(prompt_bufnr)
    else
      actions.close(prompt_bufnr)-- TODO: 閉じずにlistを更新することはできないか？
      for _, selection in ipairs(multi_selections) do
        vim.api.nvim_buf_delete(selection.bufnr, {force = true})
      end
      require('plugins.others').buffers()
    end
  end

  require('telescope.builtin').buffers({
    attach_mappings = function(prompt_bufnr, map)
      map({"i"}, "<C-d>",
        function()
          delete_buf(prompt_bufnr)
        end
      )
      return true
    end,
  })
end

function M.find_files()
  require('telescope.builtin').find_files({
    find_command = {
      "rg",
      "--files",
      "--hidden",
      "--follow",
      "--glob",
      "!**/.git/*"
    }
  })
end

function M.git_status()
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  require('telescope.builtin').git_status({
    attach_mappings = function(prompt_bufnr, map)
      -- <C-r>で選択したファイルをgit restoreする
      map({"i"}, "<C-r>",
        function()
          local selection = action_state.get_selected_entry()
          vim.fn.system("git restore " .. selection.value)
          actions.close(prompt_bufnr) -- TODO: 閉じずにlistを更新することはできないか？
          require('plugins.others').git_status()
        end
      )
      return true
    end,
  })
end

function M.live_grep(args)
  -- TODO: 拡張子を複数指定できるようにする
  local glob_pattern = args
  if glob_pattern then
    -- 拡張子が指定されていればそれを使用してlive_grepを呼び出す
    require('telescope.builtin').live_grep({ glob_pattern = glob_pattern })
  else
    -- 引数がない場合は通常のlive_grepを呼び出す
    require('telescope.builtin').live_grep()
  end
end

--
-- toggleterm.nvim
--
function M.lua_source_toggleterm()
  require("toggleterm").setup{
    persist_size = false
  }
end

return M
