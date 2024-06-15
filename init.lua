-- NOTE: markは使ってないのでleaderにする
vim.g.mapleader = "m"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.init_dir = vim.fn.fnamemodify(vim.fn.resolve(vim.fn.expand("<sfile>")), ":h")

-- 定数ファイル読込み
require("const")
-- TODO: プラグイン読み込み
require("lazy").setup("plugins.ui.nvim-tree")
-- 設定ファイル読み込み
require("config.init")
