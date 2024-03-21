-- 定数ファイル読み込み
require("const")

local const         = vim.g["my#const"]
local cache         = vim.fn.expand("$HOME/.cache")
local dein_dir      = vim.fn.expand(cache .. "/dein")
local dein_repo_dir = dein_dir .. "/repos/github.com/Shougo/dein.vim"

vim.g.init_dir      = vim.fn.fnamemodify(vim.fn.resolve(vim.fn.expand("<sfile>")), ":h")

-- lspどっちにするか
-- NOTE: 環境変数を使って判定するので、切り替えるときは`call dein#recache_runtimepath()`を実行する
if os.getenv("LSP_PLUGIN_SELECTION") then
  vim.g.lsp_plugin_selection = tonumber(os.getenv("LSP_PLUGIN_SELECTION"))
else
  -- defaulst: coc.nvim
  vim.g.lsp_plugin_selection = const.lsp_plugin_selection_coc
end

-- ~/.cacheが無ければ作成
if not vim.fn.isdirectory(cache) == 0 then
  vim.fn.mkdir(cache, "p")
end

-- deinが無ければインストール
if vim.fn.matchstr(vim.o.runtimepath, '/dein.vim') == "" then
  if vim.fn.isdirectory(dein_repo_dir) == 0 then
    if vim.fn.isdirectory(dein_repo_dir) == 0 then
      os.execute('git clone https://github.com/Shougo/dein.vim ' .. dein_repo_dir)
    end
  end
  vim.o.runtimepath = dein_repo_dir .. "," .. vim.o.runtimepath
end

-- dein options
vim.g["dein#auto_recache"]  = true
vim.g["dein#lazy_rplugins"] = true

-- 設定開始
if vim.fn["dein#load_state"](dein_dir) == 1 then
  -- vimrc {{{
  local init                  = vim.g.init_dir .. '/lua/config/init.lua'
  local options               = vim.g.init_dir .. '/lua/config/options.lua'
  local autocmds              = vim.g.init_dir .. '/lua/config/autocmds.lua'
  local keymappings           = vim.g.init_dir .. '/lua/config/keymappings.lua'

  vim.g["dein#inline_vimrcs"] = {
    -- NOTE: 読込み順には要注意
    --       initが一番上にいないのは変な気もするけどとりあえずいいや...
    autocmds,
    init,
    options,
    keymappings,
  }
  -- }}}

  vim.fn["dein#begin"](dein_dir)

  -- toml {{{
  local toml      = vim.g.init_dir .. "/toml/dein.toml"
  local lazy_toml = vim.g.init_dir .. "/toml/dein_lazy.toml"
  local lsp

  -- lsp
  if vim.g.lsp_plugin_selection == const.lsp_plugin_selection_coc then
    lsp = vim.g.init_dir .. "/toml/coc.toml"
  elseif vim.g.lsp_plugin_selection == const.lsp_plugin_selection_mason_lspconfig then
    lsp = vim.g.init_dir .. "/toml/mason_lspconfig.toml"
  end

  vim.fn["dein#load_toml"](toml, { lazy = 0 })
  vim.fn["dein#load_toml"](lazy_toml, { lazy = 1 })
  vim.fn["dein#load_toml"](lsp, { lazy = 1 })
  -- }}}

  vim.fn["dein#end"]()
  vim.fn["dein#save_state"]()
end

-- 未インストールがあればインストール
if (vim.fn['dein#check_install']() ~= 0) then
  vim.fn['dein#install']()
end

vim.cmd([[
  " ファイル形式別プラグインの有効化
  filetype plugin indent on
  " シンタックスハイライトの有効化
  syntax enable
]])
