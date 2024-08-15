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
      if -- readonlyなら何もしない
          vim.o.readonly or
          -- commit編集時は何もしない
          vim.fn.expand('%:t') == "COMMIT_EDITMSG" or
          -- quickfix windowの時は何もしない
          vim.o.filetype == "qf" or
          -- diffviewが開いていたら何もしない
          require("utils.utils").is_open_diffview() or
          -- 無名バッファのみの場合は何もしない(時々Sessionファイルが空になることがあるからその対策)
          require("utils.utils").is_only_no_name_buf()
      then
        -- 何もせず終了
        return
      end

      -- vim起動時のカレントディレクトリ
      local pwd_in_startup = vim.fn.expand('$PWD')
      -- セッション保存コマンド
      local mksession_command = 'mksession! ' .. pwd_in_startup .. '/Session.vim'
      -- session保存
      vim.cmd(mksession_command)
    end
  }
)

-- Git情報を更新
au({ "BufWrite" }, {
  group = "MyAutocmds",
  callback = function()
    vim.fn["utils#git_info#refresh_git_infomation"]()
  end
})
au({ "VimResume", "FileChangedShellPost", "DirChanged" }, {
  group = "MyAutocmds",
  callback = function()
    vim.fn['utils#git_info#refresh_git_infomation'](true)
  end
})

-- env系はshとして開く
au({ "BufRead", "BufNewFile" }, {
  group = "MyAutocmds",
  pattern = { ".env", ".env.*" },
  command = "set ft=sh",
})

-- messages
au({ "BufRead", "BufNewFile" }, {
  group = "MyAutocmds",
  pattern = { "syslog*" },
  command = "set ft=messages",
})

-- coc-settings.jsonはjsoncとして開く
au({ "BufRead", "BufNewFile" }, {
  group = "MyAutocmds",
  pattern = { "coc-settings.json" },
  command = "set ft=jsonc",
})

-- アノテーションコメントのハイライト
au({ "WinEnter", "BufRead", "BufNewFile", "Syntax", "Colorscheme" }, {
  group = "MyAutocmds",
  pattern = "*",
  callback = function()
    vim.fn.matchadd('Note', 'NOTE', -1)
    vim.fn.matchadd('Todo', 'TODO', -1)
    vim.fn.matchadd('Fixme', 'FIXME', -1)
    vim.api.nvim_set_hl(0, 'Note', { fg = "LightGray", bold = true })
    vim.api.nvim_set_hl(0, 'Todo', { fg = "DarkYellow", bold = true })
    vim.api.nvim_set_hl(0, 'Fixme', { fg = "Red", bold = true })
  end,
})

-- viewの保存
au({ "BufWritePost" }, {
  group = "MyAutocmds",
  pattern = "*",
  callback = function()
    if vim.fn.expand('%') == '' or string.match(vim.bo.buftype, 'nofile') then
      return
    end
    vim.cmd([[mkview]])
  end,
})

-- viewの読み込み
au({ "BufRead" }, {
  group = "MyAutocmds",
  pattern = "*",
  callback = function()
    if vim.fn.expand('%') == '' or string.match(vim.bo.buftype, 'nofile') then
      return
    end
    vim.cmd([[
      try
        silent loadview
      catch
      endtry
    ]])
  end,
})

-- commentstring
-- NOTE: ftpluginに入れても良いけど、一箇所に集めた方が分かりやすいからここで設定する
au("FileType", {
  group = "MyAutocmds",
  pattern = { "applescript", "toml" },
  callback = function()
    vim.bo.commentstring = "# %s"
  end
})
au("FileType", {
  group = "MyAutocmds",
  pattern = { "php", "jsonc" },
  callback = function()
    vim.bo.commentstring = "// %s"
  end
})
au("FileType", {
  group = "MyAutocmds",
  pattern = { "vue" },
  callback = function()
    vim.bo.commentstring = "<!-- %s -->"
  end
})
au("FileType", {
  group = "MyAutocmds",
  pattern = { "vim" },
  callback = function()
    vim.bo.commentstring = "\" %s"
  end
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
    if string.match(vim.g.colors_name, "^tokyonight-.*") then
      require("plugins.colorscheme.tokyonight").set_customcolor()
    elseif vim.g.colors_name == "moonlight" then
      require("plugins.colorscheme.moonlight").set_customcolor()
    elseif vim.g.colors_name == "kanagawa" then
      require("plugins.colorscheme.kanagawa").set_customcolor()
    elseif vim.g.colors_name == "gruvbox" then
      require("plugins.colorscheme.gruvbox").set_customcolor()
    elseif vim.g.colors_name == "nightfly" then
      require("plugins.colorscheme.nightfly").set_customcolor()
    elseif string.match(vim.g.colors_name, "fox$") then
      require("plugins.colorscheme.nightfox").set_customcolor()
    elseif string.match(vim.g.colors_name, "^catppuccin-.*") then
      require("plugins.colorscheme.catppuccin").set_customcolor()
    elseif vim.g.colors_name == "everforest" then
      require("plugins.colorscheme.everforest").set_customcolor()
    else
      -- 上記以外は以下が設定される
      require("plugins.colorscheme.utils").set_customcolor_common()
    end
  end,
})
