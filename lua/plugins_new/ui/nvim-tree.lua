-- NOTE: 何か処理がある場合はreturnより前に書いてconfig内で呼ぶと良さそう
return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  cmd = {
    'NvimTreeOpen',
    'NvimTreeClose',
    'NvimTreeToggle',
    'NvimTreeFocus',
    'NvimTreeRefresh',
    'NvimTreeFindFile',
    'NvimTreeFindFileToggle',
    'NvimTreeClipboard',
    'NvimTreeResize',
    'NvimTreeCollapse',
    'NvimTreeCollapseKeepBuffers',
    'NvimTreeGenerateOnAttach'
  },
  keys = {
    { "<C-n>",  "<Cmd>NvimTreeToggle<CR>",   desc = "" },
    { "<C-w>t", "<Cmd>NvimTreeFindFile<CR>", desc = "" },
  },
  config = function()
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
}
