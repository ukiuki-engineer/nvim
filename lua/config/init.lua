-- ==============================================================================
-- configのメインファイル
-- ==============================================================================
local au      = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local g       = vim.g
-- ------------------------------------------------------------------------------
-- 通常ロード
-- ------------------------------------------------------------------------------
-- NOTE: 以下は、deinのinline_vimrcs側で読み込んでいるので不要。
-- require("config.options")
-- require("config.autocmds")
-- require("config.keymappings")

-- ------------------------------------------------------------------------------
-- 遅延ロード
-- ------------------------------------------------------------------------------
augroup("my_lazyload", {}) -- {{{

-- NOTE: プラグインを前提とした処理はVimEnterに
au("VimEnter", {
  group = "my_lazyload",
  callback = function()
    vim.schedule(function()
      -- 環境ごとの設定
      local localvimrc       = g.init_dir .. "/local.vim"
      local existsLocalvimrc = require('utils').bool_fn.filereadable(localvimrc)
      if existsLocalvimrc then
        -- ~/.config/nvim/local.vimがあればロード
        local cmd = [[execute "source " .. "]] .. localvimrc .. '\"'
        vim.cmd(cmd)
      else
        -- local.vimが無ければcolorschemeは↓
        -- NOTE: 気分、環境によってころころ変えたいけど、いちいちgitの差分出るのが嫌だからこういう運用
        vim.cmd([[colorscheme kanagawa]])
      end
    end)
  end,
  once = true -- VimEnterだから不要と思うけど一応...
})

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

-- タイマー遅延で起動する処理
au("VimEnter", { -- VimEnter後にタイマースタートする
  group = "my_lazyload",
  callback = function()
    vim.fn.timer_start(
      g["my#const"].timer_start_init,
      function()
        -- Git情報を更新
        if require('utils').is_git_project() then
          vim.fn['utils#refresh_git_infomations'](true)
        end

        -- vim設定禁止処理w
        -- ~/.config/nvim/workingがあり、~/.config/nvim/で起動した場合、強制終了する(仕事に集中したい時用)
        -- 何か良いプラグインもあるっぽいけどとりあえずこれで十分かな
        vim.cmd([[
          if filereadable(expand('~/.config/nvim/working')) && expand('%:p:h') == expand('~/.config/nvim')
            q!
          endif
        ]])

        -- カラースキーム名をnotifyする
        au("ColorScheme", {
          callback = function()
            if vim.o.filetype ~= "TelescopePrompt" then
              require('notify')("ColorScheme: " .. vim.g.colors_name)
            end
          end,
        })
      end
    )
  end,
  once = true -- VimEnterだから不要と思うけど一応...
})
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
-- vim.fn["utils#lazy_load_standard_plugins"]()
