-------------------------------------------------------------------------------
-- autocmds
-- →大体、個々の設定のとこで定義する事が多いからここに書く事はあんまり無いかも
-------------------------------------------------------------------------------
local au      = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local fn      = vim.fn
local utils   = require("utils")

augroup("MyAutocmds", {})

-- Session.vimを保存
local pwd_in_startup = fn.expand('$PWD')
local mksession = 'mksession! ' .. pwd_in_startup .. '/Session.vim'
au({ "BufWrite", "BufRead" }, {
  group = "MyAutocmds",
  callback = function()
    -- readonlyなら何もしない
    if vim.o.readonly then
      return
    end

    -- commit編集時は何もしない
    if fn.expand('%:t') == "COMMIT_EDITMSG" then
      return
    end

    -- quickfix windowの時は何もしない
    if vim.o.filetype == "qf" then
      return
    end

    -- diffviewのパネルがあったら何もしない
    if string.find(fn.join(fn.gettabinfo(), ', '), 'diffview_view') then
      return
    end

    vim.cmd(mksession)
  end
})

-- Git情報を更新
au({ "BufWrite" }, {
  group = "MyAutocmds",
  callback = function()
    vim.fn["utils#refresh_git_infomations"]()
  end
})
au({ "VimResume" }, {
  group = "MyAutocmds",
  callback = function()
    vim.fn["utils#refresh_git_infomations"](true)
  end
})

-- env系はshとして開く
au("BufRead", {
  group = "MyAutocmds",
  pattern = { ".env", ".env.*" },
  command = "set ft=sh",
})
-- ------------------------------------------------------------------------------
-- 色周りの設定を呼ぶ処理
-- 色周りの設定はlua/plugins/colorscheme.lua
-- ------------------------------------------------------------------------------
augroup("MyCustomColor", {})

if not utils.bool_fn.has("mac") then
  -- NOTE: MacはiTerm2側でスケスケにする
  au("ColorSchemePre", {
    pattern = { "tokyonight*" },
    callback = function()
      require("plugins.colorscheme.tokyonight").colorschemepre()
    end,
    group = "MyCustomColor",
  })
end

au("ColorScheme", {
  callback = function()
    if vim.g.colors_name == "tokyonight" then
      require("plugins.colorscheme.tokyonight").set_customcolor()
    elseif vim.g.colors_name == "moonlight" then
      require("plugins.colorscheme.moonlight").set_customcolor()
    elseif vim.g.colors_name == "kanagawa" then
      require("plugins.colorscheme.kanagawa").set_customcolor()
    elseif vim.g.colors_name == "gruvbox" then
      require("plugins.colorscheme.gruvbox").set_customcolor()
    elseif vim.g.colors_name == "nightfly" then
      require("plugins.colorscheme.nightfly").set_customcolor()
    else
      -- 上記以外は以下が設定される
      require("plugins.colorscheme.utils").set_customcolor_common()
    end
  end,
  group = "MyCustomColor",
})
