-- ============================================================================
-- VSÇode Neovim用の設定
-- ============================================================================
local init_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")
local config_file = init_dir .. "/config.vim"
local plugin_file = init_dir .. "/plugin.lua"

-- 設定ファイル読み込み
vim.cmd("source " .. vim.fn.fnameescape(config_file))

-- プラグイン設定読み込み
dofile(plugin_file)
