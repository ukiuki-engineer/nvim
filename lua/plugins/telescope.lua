local M = {}

local keyset = vim.keymap.set
local fn     = vim.fn

--
-- telescope.nvim
--
function M.lua_add_telescope()
  -- NOTE: on_cmdで遅延ロードさせるためにこういう回りくどいやり方をしている…
  keyset('n', '<space>b', "<Cmd>Buffers<CR>", {})
  keyset('n', '<space>f', "<Cmd>FindFiles<CR>", {})
  keyset('n', '<space>g', "<Cmd>LiveGrep<CR>", {})
end

function M.lua_source_telescope()
  local command = vim.api.nvim_create_user_command
  command('BufferLines', "lua require('telescope.builtin').current_buffer_fuzzy_find()", {})
  command('Buffers', "lua require('plugins.telescope').buffers()", {})
  command('CommandHistories', "lua require('telescope.builtin').command_history()", {})
  command('Commands', "lua require('telescope.builtin').commands()", {})
  command('Commits', "lua require('telescope.builtin').git_commits()", {})
  command('FindFiles', "lua require('plugins.telescope').find_files()", {})
  command('GitBranches', "lua require('telescope.builtin').git_branches()", {})
  command('GitStatus', "lua require('plugins.telescope').git_status()", {})
  command('HelpTags', "lua require('telescope.builtin').help_tags()", {})
  command('OldFiles', "lua require('telescope.builtin').oldfiles()", {})

  vim.cmd([[command! -nargs=* LiveGrep :lua require("plugins.telescope").live_grep("<args>")]])
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
            fn['skkeleton#handle']('toggle', {})
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
      require('plugins.telescope').buffers()
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
          fn.system("git restore " .. selection.value)
          actions.close(prompt_bufnr) -- TODO: 閉じずにlistを更新することはできないか？
          require('plugins.telescope').git_status()
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

return M
