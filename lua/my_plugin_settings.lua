-- ================================================================================
-- 各プラグインの設定(lua)
-- NOTE: 関数の命名規則
-- - "hookの種類_プラグイン名"とする
-- - ハイフンはアンダーバーに変更
-- - 以下は省略する
--   - "vim-"
--   - "nvim-"
--   - ".vim"
--   - ".nvim"
--   - ".lua"
-- ================================================================================
local M = {}

--
-- lualine.nvim
--
M.lua_add_lualine = function()
  require('lualine').setup({
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'}, -- TODO: user.nameとuser.emailも表示させたい
      lualine_c = {
        {
          'filename',
          file_status = true,      -- Displays file status (readonly status, modified status)
          newfile_status = false,  -- Display new file status (new file means no write after created)
          path = 1,                -- 0: Just the filename
                                   -- 1: Relative path
                                   -- 2: Absolute path
                                   -- 3: Absolute path, with tilde as the home directory
                                   -- 4: Filename and parent dir, with tilde as the home directory
          shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
                                   -- for other components. (terrible name, any suggestions?)
          symbols = {
            modified = '[+]',      -- Text to show when the file is modified.
            readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
            unnamed = '[No Name]', -- Text to show for unnamed buffers.
            newfile = '[New]',     -- Text to show for newly created file before first write
          }
        }
      },
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        {
          'filename',
          file_status = true,      -- Displays file status (readonly status, modified status)
          newfile_status = false,  -- Display new file status (new file means no write after created)
          path = 1,                -- 0: Just the filename
                                   -- 1: Relative path
                                   -- 2: Absolute path
                                   -- 3: Absolute path, with tilde as the home directory
                                   -- 4: Filename and parent dir, with tilde as the home directory
          shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
                                   -- for other components. (terrible name, any suggestions?)
          symbols = {
            modified = '[+]',      -- Text to show when the file is modified.
            readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
            unnamed = '[No Name]', -- Text to show for unnamed buffers.
            newfile = '[New]',     -- Text to show for newly created file before first write
          }
        }
      },
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {
      lualine_a = {'tabs'},
      lualine_b = {
        {
          'filename',
          file_status = true,      -- Displays file status (readonly status, modified status)
          newfile_status = false,  -- Display new file status (new file means no write after created)
          path = 1,                -- 0: Just the filename
                                   -- 1: Relative path
                                   -- 2: Absolute path
                                   -- 3: Absolute path, with tilde as the home directory
                                   -- 4: Filename and parent dir, with tilde as the home directory
          shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
                                   -- for other components. (terrible name, any suggestions?)
          symbols = {
            modified = '[+]',      -- Text to show when the file is modified.
            readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
            unnamed = '[No Name]', -- Text to show for unnamed buffers.
            newfile = '[New]',     -- Text to show for newly created file before first write
          }
        }
      },
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {'buffers'}
    }
  })
end


--
-- nvim-treesitter
--
M.lua_source_treesitter = function()
  -- NOTE: 逆にデフォルトの方が見やすい場合はtreesitterを適宜オフに設定する
  require('nvim-treesitter.configs').setup {
    highlight = {
      enable = true, -- syntax highlightを有効にする
      disable = {    -- デフォルトの方が見やすい場合は無効に
      }
    },
    indent = {
      enable = true
    },
    matchup = {
      -- enable = true,              -- mandatory, false will disable the whole extension
      -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
    },
    ensure_installed = 'all' -- :TSInstall allと同じ
  }
end

--
-- vim-nightfly-colors
--
M.lua_add_nightfly_colors = function()

  local my_functions = require("my_functions")
  local bg_color = "#011627" -- :hi Normal


  local function fix_nightfly()
    -- diffview
    vim.api.nvim_set_hl(0, 'DiffviewDiffAddAsDelete', { -- FIXME: 不明
      bg = "#FF0000"
    })
    vim.api.nvim_set_hl(0, 'DiffDelete', {              -- 削除された行
      bg = my_functions.transparent_color(bg_color, "#C70000", 0.90)
    })
    vim.api.nvim_set_hl(0, 'DiffviewDiffDelete', {      -- 行が追加された場合の左側
      bg = my_functions.transparent_color(bg_color, "#C70000", 0.90),
      fg = my_functions.transparent_color(bg_color, "#2F2F2F", 0.00)
    })
    vim.api.nvim_set_hl(0, 'DiffAdd', {                 -- 追加された行
      bg = my_functions.transparent_color(bg_color, "#00A100", 0.85)
    })
    vim.api.nvim_set_hl(0, 'DiffChange', {              -- 変更行
      bg = my_functions.transparent_color(bg_color, "#B9C42F", 0.90)
    })
    vim.api.nvim_set_hl(0, 'DiffText', {                -- 変更行の変更箇所
      bg = my_functions.transparent_color(bg_color, "#FD7E00", 0.70)
    })
    -- coc.nvim
    vim.api.nvim_set_hl(0, 'CocFadeOut', {
      bg = my_functions.transparent_color(bg_color, '#ADABAC', 0.50),
      fg = "LightGrey"
    })
    vim.api.nvim_set_hl(0, 'CocHintSign', { fg = "LightGrey" })
    vim.api.nvim_set_hl(0, 'CocHighlightText', {
      bg = my_functions.transparent_color(bg_color, "LightGrey", 0.55),
    })
    -- vim-matchup
    vim.api.nvim_set_hl(0, 'MatchParen', {
      bg = my_functions.transparent_color(bg_color, "LightGrey", 0.75),
      bold = true,
      underline = true
    })
  end

  local custom_highlight = vim.api.nvim_create_augroup("CustomHighlight", {})

  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = {"nightfly"},
    callback = fix_nightfly,
    group = custom_highlight,
  })

  vim.cmd [[colorscheme nightfly]]
end

--
-- gruvbox.nvim
--
M.lua_add_gruvbox = function()
  local colors = require("gruvbox.palette").colors;
  local my_functions = require("my_functions")
  local bg_color = "#282828" -- :hi Normal

  -- ハイライト色を色々と変更
  function fix_gruvbox()
    -- diffview
    vim.api.nvim_set_hl(0, 'DiffviewDiffAddAsDelete', { -- FIXME: 不明
      bg = "#FF0000"
    })
    vim.api.nvim_set_hl(0, 'DiffDelete', {              -- 削除された行
      bg = my_functions.transparent_color(bg_color, "#C70000", 0.90)
    })
    vim.api.nvim_set_hl(0, 'DiffviewDiffDelete', {      -- 行が追加された場合の左側
      bg = my_functions.transparent_color(bg_color, "#C70000", 0.90),
      fg = colors.dark2
    })
    vim.api.nvim_set_hl(0, 'DiffAdd', {                 -- 追加された行
      bg = my_functions.transparent_color(bg_color, "#009900", 0.85)
    })
    vim.api.nvim_set_hl(0, 'DiffChange', {              -- 変更行
      bg = my_functions.transparent_color(bg_color, "#B9C42F", 0.90)
    })
    vim.api.nvim_set_hl(0, 'DiffText', {                -- 変更行の変更箇所
      bg = my_functions.transparent_color(bg_color, "#FD7E00", 0.70)
    })
    -- coc.nvim
    vim.api.nvim_set_hl(0, 'CocFadeOut', {
      bg = my_functions.transparent_color(bg_color, '#ADABAC', 0.50),
      fg = "LightGrey"
    })
    vim.api.nvim_set_hl(0, 'CocHintSign', { fg = "LightGrey" })
    vim.api.nvim_set_hl(0, 'CocHighlightText', {
      bg = my_functions.transparent_color(bg_color, "LightGrey", 0.55),
    })
    -- vim-matchup
    vim.api.nvim_set_hl(0, 'MatchParen', {
      bg = my_functions.transparent_color(bg_color, "LightGrey", 0.75),
      bold = true,
      underline = true
    })
    -- 検索
    vim.api.nvim_set_hl(0, 'Search', {
      bg = my_functions.transparent_color(bg_color, "#FABD2F", 0.70),
    })
    vim.api.nvim_set_hl(0, 'CurSearch', {
      -- bg = my_functions.transparent_color(bg_color, "#FE8019", 0.35),
      bg = my_functions.transparent_color(bg_color, "#FABD2F", 0.50),
    })
    vim.api.nvim_set_hl(0, 'IncSearch', {
      -- bg = my_functions.transparent_color(bg_color, "#FE8019", 0.35),
      bg = my_functions.transparent_color(bg_color, "#FABD2F", 0.50),
    })
  end

  local custom_highlight = vim.api.nvim_create_augroup("CustomHighlight", {})

  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = { "gruvbox" },
    callback = fix_gruvbox,
    group = custom_highlight,
  })
  vim.o.background = "dark"
  vim.cmd [[colorscheme gruvbox]]
end

--
-- diffview.nvim
--
M.lua_source_diffview = function()
  -- NOTE: マウスでスクロールする時は、差分の右側をスクロールしないとスクロールが同期されない
  -- TODO: 差分をdiscardする時、confirmするようにする
  require('diffview').setup ({
    enhanced_diff_hl = true,
    file_panel = {
      win_config = { -- diffviewのwindowの設定
        type = "split",
        position = "right",
        width = 40,
      },
    },
  })
end

--
-- indent-blankline.nvim
--
M.lua_source_indent_blankline = function()
  vim.opt.list = true
  vim.opt.listchars:append({
    space = "⋅",
    tab = "»-",
    trail = "-",
    eol = "↲",
    extends = "»",
    precedes = "«",
    nbsp = "%"
  })
  require("indent_blankline").setup {
    show_end_of_line = true,
    space_char_blankline = " "
  }
end

--
-- nvim-tree
--
M.lua_source_nvim_tree = function()
  require("nvim-tree").setup {
    git = {
      ignore = false,          -- .gitignoreされたファイルもtreeに表示する
    },
    -- 以下、treeのrootに関する設定
    -- prefer_startup_root = true,
    sync_root_with_cwd = true, -- `:cd`, `:tcd`と同期
    update_focused_file = {
      enable = false,          -- カレントバッファに合わせて常に更新
      update_root = true,      -- `:NvimTreeFindFile`すると更新
      ignore_list = {},
    },
  }
end

--
-- nvim-cmp
--
M.lua_source_nvim_cmp = function()
  -- TODO: `:ls`→`:`の時は補完しように(補完ウィンドウが出ると`:ls`の結果が全部消える...)
  local cmp = require 'cmp'
  -- 検索
  cmp.setup.cmdline({'/', '?'}, {
    mapping = cmp.mapping.preset.cmdline({
      ["<C-p>"] = cmp.mapping.scroll_docs(-1),
      ["<C-n>"] = cmp.mapping.scroll_docs(1),
    }),
    sources = {
      { name = 'buffer' }
    }
  })
  -- コマンド
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline({
      ["<C-p>"] = cmp.mapping.scroll_docs(-1),
      ["<C-n>"] = cmp.mapping.scroll_docs(1),
    }),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
end

return M