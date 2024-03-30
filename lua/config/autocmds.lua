-------------------------------------------------------------------------------
-- autocmds
-- →個々の設定のとこでも色々定義してるけど、全体的な設定はここに配置する。
-------------------------------------------------------------------------------
local au      = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

augroup("MyAutocmds", {})

-- Session.vimを保存
au({ "BufWrite", "BufRead", "TabNew", "TabClosed", "WinNew", "WinClosed" },
  {
    group = "MyAutocmds",
    callback = function()
      -- vim起動時のカレントディレクトリ
      local pwd_in_startup = vim.fn.expand('$PWD')
      -- セッション保存コマンド
      local mksession_command = 'mksession! ' .. pwd_in_startup .. '/Session.vim'

      -- readonlyなら何もしない
      if vim.o.readonly then
        return
      end

      -- commit編集時は何もしない
      if vim.fn.expand('%:t') == "COMMIT_EDITMSG" then
        return
      end

      -- quickfix windowの時は何もしない
      if vim.o.filetype == "qf" then
        return
      end

      -- diffviewのパネルがあったら何もしない
      if string.find(vim.fn.join(vim.fn.gettabinfo(), ', '), 'diffview_view') then
        return
      end

      -- session保存
      vim.cmd(mksession_command)
    end
  }
)

-- Git情報を更新
au({ "BufWrite" }, {
  group = "MyAutocmds",
  callback = function()
    vim.fn["git_info#refresh_git_infomation"]()
  end
})
au({ "VimResume", "FileChangedShellPost", "DirChanged" }, {
  group = "MyAutocmds",
  callback = function()
    vim.fn['git_info#refresh_git_infomation'](true)
  end
})

-- env系はshとして開く
au({ "BufRead", "BufNewFile" }, {
  group = "MyAutocmds",
  pattern = { ".env", ".env.*" },
  command = "set ft=sh",
})

-- coc-settings.jsonはjsoncとして開く
au({ "BufRead", "BufNewFile" }, {
  group = "MyAutocmds",
  pattern = { "coc-settings.json" },
  command = "set ft=jsonc",
})

-- アノテーションコメントのハイライト
au({ "WinEnter", "BufRead", "BufNewFile", "Syntax" }, {
  group = "MyAutocmds",
  pattern = "*",
  callback = function()
    vim.fn.matchadd('Note', 'NOTE', -1)
    vim.fn.matchadd('Todo', 'TODO', -1)
    vim.fn.matchadd('Fixme', 'FIXME', -1)
  end,
})
au({ "WinEnter", "BufRead", "BufNewFile", "Syntax" }, {
  group = "MyAutocmds",
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, 'Note', { fg = "White", bold = true })
    vim.api.nvim_set_hl(0, 'Todo', { fg = "Yellow", bold = true })
    vim.api.nvim_set_hl(0, 'Fixme', { fg = "Red", bold = true })
  end,
})
-- ------------------------------------------------------------------------------
-- colorschemeごとの設定
-- ------------------------------------------------------------------------------
augroup("MyCustomColor", {})

au("ColorSchemePre", {
  group = "MyCustomColor",
  pattern = "tokyonight*",
  callback = function()
    require("plugins.colorscheme.tokyonight").colorscheme_pre()
  end,
})

au("ColorSchemePre", {
  group = "MyCustomColor",
  pattern = "nightfly",
  callback = function()
    require("plugins.colorscheme.nightfly").colorscheme_pre()
  end,
})

au("ColorSchemePre", {
  group = "MyCustomColor",
  pattern = "kanagawa*",
  callback = function()
    require("plugins.colorscheme.kanagawa").colorscheme_pre()
  end,
})

au("ColorSchemePre", {
  group = "MyCustomColor",
  pattern = "moonlight",
  callback = function()
    require("plugins.colorscheme.moonlight").colorscheme_pre()
  end,
})

au("ColorScheme", {
  group = "MyCustomColor",
  pattern = "*",
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
    elseif vim.g.colors_name == "nightfox" then
      require("plugins.colorscheme.nightfox").set_customcolor()
    else
      -- 上記以外は以下が設定される
      require("plugins.colorscheme.utils").set_customcolor_common()
    end
  end,
})
