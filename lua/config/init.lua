-- ==============================================================================
-- configのメインファイル
-- ==============================================================================
local au      = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local g       = vim.g
local utils   = require("utils")
-- ------------------------------------------------------------------------------
-- 通常ロード
-- ------------------------------------------------------------------------------
-- NOTE: deinのinline_vimrcs側で読み込んでいるので不要
-- require("const")
-- require("config.options")
-- require("config.autocmds")
-- require("config.keymappings")
-- ------------------------------------------------------------------------------
-- 遅延ロード
-- ------------------------------------------------------------------------------
augroup("my_lazyload", {}) -- {{{
-- comannds
au("CmdlineEnter", {
  group = "my_lazyload",
  callback = function()
    require("config.lazy.commands")
  end,
  once = true
})
-- Terminalモードの設定
au({ "TermOpen", "CmdUndefined" }, {
  group = "my_lazyload",
  callback = function()
    require("config.lazy.terminal")
  end,
  pattern = { "Term", "TermHere", "TermHereV", "TermV", "Terminal" },
  once = true
})
-- IME切り替え設定(WSLの場合Windows領域へのI/Oが遅く、それが起動時間に影響するため遅延ロードする)
au({ "InsertEnter", "CmdlineEnter" }, {
  group = "my_lazyload",
  callback = function()
    require("config.lazy.ime")
  end,
  once = true
})
-- クリップボード設定(WSLの場合Windows領域へのI/Oが遅く、それが起動時間に影響するため遅延ロードする)
au({ "InsertEnter", "CursorMoved" }, {
  group = "my_lazyload",
  callback = function()
    require("config.lazy.clipboard")
  end,
  once = true
})
-- markdownで画像をクリップボードから貼り付け
-- TODO: lua移行後動作未確認
au("CmdUndefined", {
  group = "my_lazyload",
  callback = function()
    require("config.lazy.paste_image")
  end,
  pattern = { "PasteImage" },
  once = true
})
-- }}}


-- タイマー遅延
vim.fn.timer_start(
  g["my#const"].timer_start_init,
  function()
    if utils.is_git_project() then
      -- gitの情報を更新
      vim.fn['utils#refresh_git_infomations']()
    end

    -- ~/.config/nvim/workingがあり、~/.config/nvim/で起動した場合、強制終了する(仕事に集中したい時用)
    -- TODO: 何か良いプラグインもあるっぽいので後で調べる。一旦これで
    vim.cmd([[
    if filereadable(expand('~/.config/nvim/working')) && expand('%:p:h') == expand('~/.config/nvim')
      if filereadable(expand('~/.config/nvim/working')) && expand('%:p:h') == expand('~/.config/nvim')
        q!
      endif
    endif
    ]])
  end
)
-- ------------------------------------------------------------------------------
-- colorscheme
-- ------------------------------------------------------------------------------
augroup("MyCustomColor", {})
au("ColorSchemePre", {
  pattern = { "tokyonight*" },
  callback = function()
    require("plugins.colorscheme").tokyonight_transparent()
  end,
  group = "MyCustomColor",
})
au("ColorScheme", {
  callback = function()
    if vim.g.colors_name == "tokyonight" then
      return
    end
    -- ハイライト設定を適用
    require("plugins.colorscheme").set_customcolor()
  end,
  group = "MyCustomColor",
})
-- ------------------------------------------------------------------------------
-- localvimrc
-- ------------------------------------------------------------------------------
-- NOTE: ~/.config/nvim/local.vimがあればロード
local localvimrc = g.init_dir .. "/local.vim"
if vim.fn.filereadable(localvimrc) == 1 then
  local cmd = [[execute "source " .. "]] .. localvimrc .. '\"'
  vim.cmd(cmd)
else
  -- local.vimが無ければcolorschemeは↓
  -- 気分、環境によってころころ変えたいけど、いちいちgitの差分出るのが嫌だからこういう運用
  vim.cmd([[colorscheme gruvbox]])
end
-- ------------------------------------------------------------------------------
-- 標準プラグインの制御
-- ------------------------------------------------------------------------------
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
-- vim.fn["utils#lazy_load"]()
