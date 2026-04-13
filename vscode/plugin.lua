-- ============================================================================
-- VSCode Neovim用 プラグイン設定(エントリーポイント)
-- ============================================================================
local init_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")
local pre_file = init_dir .. "/plugin_pre.lua"
local plugins_file = init_dir .. "/plugins.lua"
local post_file = init_dir .. "/plugin_post.lua"

local path_package = vim.fn.stdpath("data") .. "/site"
local mini_path = path_package .. "/pack/deps/start/mini.nvim"
local uv = vim.uv or vim.loop

if not uv.fs_stat(mini_path) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/nvim-mini/mini.nvim",
    mini_path,
  })
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to install mini.nvim", vim.log.levels.ERROR)
    return
  end
end

vim.cmd("packadd mini.nvim")
local deps = require("mini.deps")
deps.setup({ path = { package = path_package } })

-- プラグイン読み込み前設定
if vim.fn.filereadable(pre_file) == 1 then
  dofile(pre_file)
end

-- プラグイン追加
if vim.fn.filereadable(plugins_file) == 1 then
  local register_plugins = dofile(plugins_file)
  if type(register_plugins) == "function" then
    register_plugins(deps)
  end
end

-- プラグイン読み込み後設定
if vim.fn.filereadable(post_file) == 1 then
  dofile(post_file)
end
