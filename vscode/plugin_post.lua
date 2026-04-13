-- ==========================================================================
-- プラグイン読み込み後設定
-- ==========================================================================

-- vim-edgemotion
vim.keymap.set({ "n", "x" }, "<C-j>", "<Plug>(edgemotion-j)", { silent = true })
vim.keymap.set({ "n", "x" }, "<C-k>", "<Plug>(edgemotion-k)", { silent = true })

-- oil.nvim
require("oil").setup({
  win_options = {
    signcolumn = "yes:2",
  },
  view_options = {
    show_hidden = true,
  }
})
