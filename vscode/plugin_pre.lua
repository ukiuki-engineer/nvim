-- ==========================================================================
-- プラグイン読み込み前設定
-- ==========================================================================

-- vim-highlightedyank
vim.g.highlightedyank_highlight_duration = 500

-- oil.nvim
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
