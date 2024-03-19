local M = {}

function M.lua_add()
  vim.keymap.set('n', '<C-n>', "<Cmd>NvimTreeToggle<CR>", {})
  vim.keymap.set('n', '<C-w>t', "<Cmd>NvimTreeFindFile<CR>", {})
end

function M.lua_source()
  require("nvim-tree").setup {
    git = {
      ignore = false,          -- .gitignoreされたファイルもtreeに表示する
    },
    sync_root_with_cwd = true, -- `:cd`, `:tcd`と同期
    update_focused_file = {
      enable = false,          -- カレントバッファに合わせて常に更新
      update_root = true,      -- `:NvimTreeFindFile`すると更新
      ignore_list = {},
    },
    view = {
      -- sizeを動的に調整する
      width = {
        min = 5,
        max = 75,
        padding = 1
      }
    },
  }
end

return M
