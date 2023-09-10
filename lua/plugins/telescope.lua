local keyset                 = vim.keymap.set
local fn                     = vim.fn
local utils                  = require('utils')

-- commit数の状態を返す
local git_commit_status_text = function()
  local remote_branch_info_text = utils.remote_branch_info_text()
  local commit = vim.g['my#git_infomations']['commit_count']

  if remote_branch_info_text ~= "" then
    return remote_branch_info_text
  elseif commit['remote'] == "" and commit['local'] == "" then
    return ""
  else
    return "↓" .. commit['remote'] .. " ↑" .. commit['local']
  end
end

--

local M                      = {}

function M.lua_add_telescope()
  -- NOTE: on_cmdで遅延ロードさせるためにこういう回りくどいやり方をしている…
  keyset('n', '<space>b', "<Cmd>Buffers<CR>", {})
  keyset('n', '<space>c', "<Cmd>Commits<CR>", {})
  keyset('n', '<space>f', "<Cmd>FindFiles<CR>", {})
  keyset('n', '<space>g', "<Cmd>LiveGrep<CR>", {})
  keyset('n', '<space>s', "<Cmd>GitStatus<CR>", {})
  keyset('n', '<Left>', "<Cmd>GitStatus<CR>", {})
end

function M.lua_source_telescope()
  local command = vim.api.nvim_create_user_command
  command('BufferLines', "lua require('telescope.builtin').current_buffer_fuzzy_find()", {})
  command('Buffers', "lua require('plugins.telescope').buffers()", {})
  command('ColorSchemes', "lua require('telescope.builtin').colorscheme({enable_preview = true})", {})
  command('CommandHistories', "lua require('telescope.builtin').command_history()", {})
  command('Commands', "lua require('telescope.builtin').commands()", {})
  command('Commits', "lua require('plugins.telescope').git_commits()", {})
  command('FindFiles', "lua require('plugins.telescope').find_files()", {})
  command('GitBranches', "lua require('plugins.telescope').git_branches()", {})
  command('GitStash', "lua require('telescope.builtin').git_stash()", {})
  command('GitStatus', "lua require('plugins.telescope').git_status()", {})
  command('HelpTags', "lua require('telescope.builtin').help_tags()", {})
  command('Marks', "lua require('telescope.builtin').marks()", {})
  command('OldFiles', "lua require('telescope.builtin').oldfiles()", {})

  vim.cmd([[command! -nargs=* LiveGrep :lua require("plugins.telescope").live_grep("<args>")]])
  -- NOTE: ↑の使用例:
  -- :LiveGrep *.toml

  require('telescope').setup({
    defaults = {
      layout_strategy = 'horizontal',
      layout_config = {
        height     = 0.90,
        width      = 0.95,
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

--------------------------------------------------------------------------------
-- functions
--------------------------------------------------------------------------------
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
      actions.close(prompt_bufnr) -- TODO: 閉じずにlistを更新することはできないか？
      for _, selection in ipairs(multi_selections) do
        vim.api.nvim_buf_delete(selection.bufnr, { force = true })
      end
      require('plugins.telescope').buffers()
    end
  end

  require('telescope.builtin').buffers({
    attach_mappings = function(prompt_bufnr, map)
      -- bufferを削除
      map({ "n" }, "<leader>dd",
        function()
          delete_buf(prompt_bufnr)
        end
      )
      return true
    end,
  })
end

function M.git_commits()
  require('telescope.builtin').git_commits({
    git_command = {
      "git",
      "log",
      "--date=short",
      "--pretty=%C(auto)%h %C(blue)%ad [%C(green)%an%C(reset)] %s",
      "--abbrev-commit",
      "--",
      "."
    }
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

function M.git_branches()
  local actions = require('telescope.actions')
  require('telescope.builtin').git_branches({
    attach_mappings = function(prompt_bufnr, map)
      -- checkoutしてgit情報を更新する
      map({ "i", "n" }, "<CR>",
        function()
          -- checkout
          actions.git_checkout_current_buffer(prompt_bufnr) -- ここまでがデフォルトの動き
          -- git情報を更新(lualine用)
          -- NOTE: lualineのgit情報を更新するために必要
          vim.fn["utils#refresh_git_infomations"]()
        end
      )
      return true
    end,
  })
end

function M.git_status()
  if not require("utils").is_git_project() then
    vim.cmd([[
      echohl WarningMsg
      echo "this directory is not a git project!"
      echohl None
    ]])
    return
  end

  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  -- git情報を更新
  vim.fn['utils#refresh_git_infomations']()

  require('telescope.builtin').git_status({
    attach_mappings = function(prompt_bufnr, map)
      -- 選択したファイルをgit restore or 削除する
      map({ "i", "n" }, "<C-r>",
        function()
          if not vim.fn["utils#confirm"]("delete this change?") then
            return
          end
          local selection = action_state.get_selected_entry()
          if fn.system("git status " .. selection.value .. " --porcelain | grep '??'") ~= "" then
            -- untrackedな場合、ファイルを削除する
            fn.delete(selection.value)
          else
            -- untrackedではない場合、restoreする
            fn.system("git restore " .. selection.value)
          end
          -- git情報を更新(lualine用)
          vim.fn["utils#refresh_git_infomations"]()
          actions.close(prompt_bufnr) -- TODO: 閉じずにlistを更新することはできないか？
          require('plugins.telescope').git_status()
        end
      )
      return true
    end,
    prompt_prefix = " " .. vim.g["my#git_infomations"]['branch_name'] .. " " .. git_commit_status_text() .. " > "
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
