-- ------------------------------------------------------------------------------
-- 遅延ロード
-- ------------------------------------------------------------------------------
local augroup = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd
local fn = vim.fn

augroup("my_lazyload", {})
-- comannds
au("CmdlineEnter", {
  group = "my_lazyload",
  callback = function()
    require("config.lazy.commands")
  end,
  once = true
})
-- keymaps
au({"InsertEnter", "BufRead"}, {
  group = "my_lazyload",
  callback = function()
    require("config.lazy.keymappings")
  end,
  once = true,
})
-- :terminal設定の読み込み1
au("TermOpen", {
  group = "my_lazyload",
  callback = function()
    require("config.lazy.terminal")
  end,
  once = true
})
-- :terminal設定の読み込み2
au("CmdUndefined", {
  group = "my_lazyload",
  callback = function()
    require("config.lazy.terminal")
  end,
  pattern = {"Terminal", "Term", "TermV", "TermHere", "TermHereV"},
  once = true
})
-- IME切り替え設定の読み込み(WSLの場合Windows領域へのI/Oが遅く、それが起動時間に影響するため遅延ロードする)
au({"InsertEnter", "CmdlineEnter"}, {
  group = "my_lazyload",
  callback = function()
    require("config.lazy.ime")
  end,
  once = true
})
-- クリップボード設定の遅延読み込み(WSLの場合Windows領域へのI/Oが遅く、それが起動時間に影響するため遅延ロードする)
au({"InsertEnter", "CursorMoved"}, {
  group = "my_lazyload",
  callback = function()
    require("config.lazy.clipboard")
  end,
  once = true
})
-- markdownで、画像をクリップボードから貼り付けする設定の読み込み
-- TODO: lua以降後動作未確認
au("CmdUndefined", {
  group = "my_lazyload",
  callback = function()
    require("config.lazy.paste_image")
  end,
  pattern = {"PasteImage"},
  once = true
})

-- ------------------------------------------------------------------------------
-- 標準プラグインの制御
-- ------------------------------------------------------------------------------
local g = vim.g
g.did_indent_on             = 1
g.did_install_default_menus = 1
g.did_install_syntax_menu   = 1
g.did_load_ftplugin         = 1
g.loaded_gzip               = 1
g.loaded_man                = 1
g.loaded_matchit            = 1
g.loaded_matchparen         = 1
g.loaded_netrw              = 1
g.loaded_netrwPlugin        = 1
g.loaded_remote_plugins     = 1
g.loaded_shada_plugin       = 1
g.loaded_spellfile_plugin   = 1
g.loaded_tarPlugin          = 1
g.loaded_tarPlugin          = 1
g.loaded_tutor_mode_plugin  = 1
g.loaded_zipPlugin          = 1
g.skip_loading_mswin        = 1
-- 標準プラグインの遅延読み込み
-- fn["utils#lazy_load"]()
-- ------------------------------------------------------------------------------
-- FIXME: 応急処置。いつか消す。
-- 最近macの時だけvimが落ちるようになったので、応急処置として保存時にmksessionする
-- ------------------------------------------------------------------------------
-- TODO: 動作未確認
if fn.has('mac') == 1 then
  local pwd_in_startup = fn.expand('$PWD')
  local command = 'mksession! ' .. pwd_in_startup .. '/Session.vim'
  augroup("auto_mksession", {})
  au("FileType", {
    group = "auto_mksession",
    pattern = {"BufWrite"},
    callback = function()
      vim.cmd(command)
    end
  })
end
