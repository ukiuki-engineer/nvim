--
-- NOTE: Git操作もある程度はできるようにしてるけど、
--       最近はdiffviewとかシェルでの操作が多いかも。
--

-- checkoutしてgit情報を更新する
local checkout_and_refresh_git_infomations = function(prompt_bufnr)
  local actions = require('telescope.actions')
  -- checkout
  actions.git_checkout_current_buffer(prompt_bufnr)
  -- git情報を更新(lualine用)
  -- NOTE: lualineのgit情報を更新するために必要
  vim.fn["utils#git_info#async_refresh_git_infomation"]()
end

--------------------------------------------------------------------------------
local M                                    = {}

function M.lua_source()
  local command = vim.api.nvim_create_user_command
  command('BufferLines', require('telescope.builtin').current_buffer_fuzzy_find, {})
  command('Buffers', require("plugins.others.telescope").buffers, {})
  command('ColorSchemes', require("plugins.others.telescope").colorscheme, {})
  command('CommandHistories', require('telescope.builtin').command_history, {})
  command('Commands', require('telescope.builtin').commands, {})
  command('Filetypes', require('telescope.builtin').filetypes, {})
  command('FindFiles', require("plugins.others.telescope").find_files, {})
  command('FindFilesAll', require("plugins.others.telescope").find_files_all, {})
  command('GitBranches', require("plugins.others.telescope").git_branches, {})
  command('GitCommits', require("plugins.others.telescope").git_commits, {})
  command('GitStashList', require('telescope.builtin').git_stash, {})
  command('GitStatus', require("plugins.others.telescope").git_status, {})
  command('HelpTags', require('telescope.builtin').help_tags, {})
  command('Highlights', require('telescope.builtin').highlights, {})
  command('ManPages', require('plugins.others.telescope').man_pages, {})
  command('Marks', require('telescope.builtin').marks, {})
  command('OldFiles', require('telescope.builtin').oldfiles, {})
  command('Tags', require('telescope.builtin').tags, {})

  -- NOTE: ↓の使用例:
  -- :LiveGrep *.lua,*.vim
  vim.cmd([[
    command! -nargs=* LiveGrep :lua require("plugins.others.telescope").live_grep("<args>")
  ]])

  local actions = require('telescope.actions')
  require('telescope').setup({
    defaults = {
      layout_strategy = 'horizontal',
      layout_config = {
        height     = 0.90,
        width      = 0.99,
        horizontal = {
          preview_width = 0.50
        },
      },
      mappings = {
        i = {
          ["<C-j>"] = function()
            local plug = vim.api.nvim_replace_termcodes("<Plug>(skkeleton-toggle)", true, false, true)
            vim.api.nvim_feedkeys(plug, "im", true) -- insert で remap して送る
          end,
          -- NOTE: <C-/>でkeymapのhelpを表示
          -- ["<C-/>"] = "which_key",
        },
        n = {
          ["<C-b>"] = actions.results_scrolling_up,
          ["<C-f>"] = actions.results_scrolling_down,
        },
      },
      initial_mode = "normal",
    },
    pickers = {
      -- grep系はResultを広く取りたいので水平分割
      live_grep = {
        layout_strategy = 'vertical',
      },
      current_buffer_fuzzy_find = {
        layout_strategy = 'vertical',
      }
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = false,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      media_files = {
        filetypes = { "png", "webp", "jpg", "jpeg" },
        find_cmd = "rg"
      }
    }
  })
  require('telescope').load_extension('fzf')
  require('telescope').load_extension('media_files')
end

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
      require("plugins.others.telescope").buffers()
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

function M.colorscheme()
  require('telescope.builtin').colorscheme({
    enable_preview = true,
    ignore_builtins = true
  })
end

function M.git_commits()
  require('telescope.builtin').git_commits({
    attach_mappings = function(prompt_bufnr, map)
      -- commit hashをヤンクする
      map({ "n" }, "y",
        function()
          local selection = require('telescope.actions.state').get_selected_entry()
          vim.fn.setreg('*', selection.value)
          print("Commit hash copied to system clipboard: " .. selection.value)
          require('telescope.actions').close(prompt_bufnr)
        end
      )
      -- checkoutしてgit情報を更新する
      map({ "i", "n" }, "<CR>",
        function()
          checkout_and_refresh_git_infomations(prompt_bufnr)
        end
      )
      return true
    end,
    git_command = {
      "git",
      "log",
      "--date=format:%Y/%m/%d %H:%M:%S",
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

function M.find_files_all()
  require('telescope.builtin').find_files({
    find_command = {
      "rg",
      "--files",
      "--hidden",
      "--follow",
      "--glob",
      "!**/.git/*"
    },
    no_ignore = true
  })
end

function M.git_branches()
  require('telescope.builtin').git_branches({
    attach_mappings = function(prompt_bufnr, map)
      -- checkoutしてgit情報を更新する
      map({ "i", "n" }, "<CR>",
        function()
          checkout_and_refresh_git_infomations(prompt_bufnr)
        end
      )
      return true
    end,
  })
end

function M.git_status()
  -- git projectでない場合は終了
  if not require("utils.utils").is_git_project() then
    return
  end

  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  -- commit数の状態を返す
  local git_commit_status_text = function()
    local remote_branch_info_text = require("utils.utils").remote_branch_info_text()
    local commit_counts = vim.g['utils#git_info#git_info']['commit_counts']

    if remote_branch_info_text ~= "" then
      return remote_branch_info_text
    elseif commit_counts['un_pulled'] == "" and commit_counts['un_pushed'] == "" then
      return ""
    else
      return "↓" .. commit_counts['un_pulled'] .. " ↑" .. commit_counts['un_pushed']
    end
  end

  local prompt_prefix = function()
    if not vim.g['utils#git_info#git_info'] then
      return " > "
    end
    return " " .. vim.g["utils#git_info#git_info"]['branch_name'] .. " " .. git_commit_status_text() .. " > "
  end

  -- git情報を更新
  vim.fn['utils#git_info#async_refresh_git_infomation'](true)

  require('telescope.builtin').git_status({
    attach_mappings = function(prompt_bufnr, map)
      -- 選択したファイルをgit restore or 削除する(つまり変更を破棄する)
      map({ "i", "n" }, "<C-r>",
        function()
          if not vim.fn["utils#utils#confirm"]("delete this change?") then
            return
          end
          local selection = action_state.get_selected_entry()
          if vim.fn.system("git status " .. selection.value .. " --porcelain | grep '??'") ~= "" then
            -- untrackedな場合、ファイルを削除する
            vim.fn.delete(selection.value)
          else
            -- untrackedではない場合、restoreする
            vim.fn.system("git restore " .. selection.value)
          end
          -- git情報を更新(lualine用)
          vim.fn["utils#git_info#async_refresh_git_infomation"]()
          actions.close(prompt_bufnr) -- TODO: 閉じずにlistを更新することはできないか？
          require("plugins.others.telescope").git_status()
        end,
        { desc = "discard this change" }
      )
      return true
    end,
    prompt_prefix = prompt_prefix(),
  })
end

function M.man_pages()
  require('telescope.builtin').man_pages({
    sections = { "ALL" }
  })
end

function M.live_grep(arg)
  -- 引数を","で分割して配列に格納する
  local glob_pattern = {}
  for match in (arg .. ","):gmatch("(.-)" .. ",") do
    table.insert(glob_pattern, match)
  end

  if glob_pattern then
    -- 拡張子が指定されていればそれを使用してlive_grepを呼び出す
    require('telescope.builtin').live_grep({ glob_pattern = glob_pattern })
  else
    -- 引数がない場合は通常のlive_grepを呼び出す
    require('telescope.builtin').live_grep()
  end
end

return M
