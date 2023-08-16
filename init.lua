local g             = vim.g
local fn            = vim.fn

g.init_dir          = fn.fnamemodify(fn.resolve(fn.expand("<sfile>")), ":h")
local cache         = fn.expand("$HOME/.cache")
local dein_dir      = fn.expand(cache .. "/dein")
local dein_repo_dir = dein_dir .. "/repos/github.com/Shougo/dein.vim"

-- ~/.cacheが無ければ作成
if not fn.isdirectory(cache) then
  fn.mkdir(cache, "p")
end

-- deinが無ければインストール
if not fn.matchstr(vim.o.runtimepath, '/dein.vim') or "" then
  if not fn.isdirectory(dein_repo_dir) then
    -- TODO: 動作未確認
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
-- 一応loading rtp pluginsに結構時間かかってるっぽいからtrueにしてみる
g["dein#lazy_rplugins"] = true
-- とりあえずhelpの値を入れてみる...
g["dein#install_check_remote_threshold"] = "24 * 60 * 60"

-- 設定開始
if fn["dein#load_state"](dein_dir) == 1 then
  -- vimrc {{{
  local init              = g.init_dir .. '/lua/config/init.lua'
  local options           = g.init_dir .. '/lua/config/options.lua'
  local autocmds          = g.init_dir .. '/lua/config/autocmds.lua'

  g["dein#inline_vimrcs"] = {
    init,
    options,
    autocmds
  }
  -- }}}

  fn["dein#begin"](dein_dir)

  -- toml {{{
  local toml      = g.init_dir .. "/toml/dein.toml"
  local lazy_toml = g.init_dir .. "/toml/dein_lazy.toml"
  fn["dein#load_toml"](toml, { lazy = 0 })
  fn["dein#load_toml"](lazy_toml, { lazy = 1 })
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
