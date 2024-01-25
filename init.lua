local g                = vim.g
local fn               = vim.fn

g.init_dir             = fn.fnamemodify(fn.resolve(fn.expand("<sfile>")), ":h")
g.lsp_plugin_selection = g["const#lsp_plugin_selection_coc"]
-- g.lsp_plugin_selection = g["const#lsp_plugin_selection_mason_lspconfig"]
local cache            = fn.expand("$HOME/.cache")
local dein_dir         = fn.expand(cache .. "/dein")
local dein_repo_dir    = dein_dir .. "/repos/github.com/Shougo/dein.vim"

-- ~/.cacheが無ければ作成
if not fn.isdirectory(cache) then
  fn.mkdir(cache, "p")
end

-- deinが無ければインストール
if not fn.matchstr(vim.o.runtimepath, '/dein.vim') or "" then
  if not fn.isdirectory(dein_repo_dir) then
    -- TODO: lua化後動作未確認
    fn.system({
      "git",
      "clone",
      "https://github.com/Shougo/dein.vim",
      dein_repo_dir
    })
  end
  vim.cmd("let &runtimepath = '" .. dein_repo_dir .. "'.','. &runtimepath")
end

-- dein options
g["dein#auto_recache"] = true
g["dein#lazy_rplugins"] = true

-- 設定開始
if fn["dein#load_state"](dein_dir) == 1 then
  -- vimrc {{{
  local const             = g.init_dir .. '/lua/const.lua'
  local init              = g.init_dir .. '/lua/config/init.lua'
  local options           = g.init_dir .. '/lua/config/options.lua'
  local autocmds          = g.init_dir .. '/lua/config/autocmds.lua'
  local keymappings       = g.init_dir .. '/lua/config/keymappings.lua'

  g["dein#inline_vimrcs"] = {
    -- NOTE: 読込み順には要注意
    --       initが一番上にいないのは変な気もするけどとりあえずいいや...
    const,
    autocmds,
    init,
    options,
    keymappings,
  }
  -- }}}

  fn["dein#begin"](dein_dir)

  -- toml {{{
  local toml      = g.init_dir .. "/toml/dein.toml"
  local lazy_toml = g.init_dir .. "/toml/dein_lazy.toml"
  local lsp

  if g.lsp_plugin_selection == g["const#lsp_plugin_selection_coc"] then
    lsp = g.init_dir .. "/toml/coc.toml"
  elseif g.lsp_plugin_selection == g["const#lsp_plugin_selection_mason_lspconfig"] then
    lsp = g.init_dir .. "/toml/mason_lspconfig.toml"
  end

  fn["dein#load_toml"](toml, { lazy = 0 })
  fn["dein#load_toml"](lazy_toml, { lazy = 1 })
  fn["dein#load_toml"](lsp, { lazy = 1 })
  -- }}}

  fn["dein#end"]()
  fn["dein#save_state"]()
end

-- 未インストールがあればインストール
if (fn['dein#check_install']() ~= 0) then
  fn['dein#install']()
end

-- ファイル形式別プラグインの有効化
vim.cmd([[filetype plugin indent on]])
-- シンタックスハイライトの有効化
vim.cmd([[syntax enable]])
