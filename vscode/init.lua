-- ============================================================================
-- VSÇode Neovim用の設定
-- ============================================================================
local init_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")
local config_file = init_dir .. "/config.vim"

-- 設定ファイル読み込み
vim.cmd('source ' .. config_file)

-- TODO: プラグインマネージャーを追加する
-- TODO: machakann/vim-highlightedyank
-- TODO: haya14busa/vim-edgemotion
-- TODO: matchupも要るかも？
