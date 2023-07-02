-- ================================================================================
-- UI
-- ================================================================================
-----------------------------------------------------------------------------------
-- private
-----------------------------------------------------------------------------------
--
-- ハイライト色をカスタムする
--
-- TODO: (TODO, FIXME, NOTE)について、どのファイルでもハイライトされるようにする
local function custom_color(bg_color, colorscheme)
  local utils = require("utils")

  local function set_customcolor()
    -- diffview
    if colorscheme ~= 'nightfox' then
      vim.api.nvim_set_hl(0, 'DiffviewDiffAddAsDelete', { -- NOTE: 不明
        bg = "#FF0000"
      })
      vim.api.nvim_set_hl(0, 'DiffDelete', {              -- 削除された行
        bg = utils.transparent_color(bg_color, "#C70000", 0.90)
      })
      vim.api.nvim_set_hl(0, 'DiffviewDiffDelete', {      -- 行が追加された場合の左側
        bg = utils.transparent_color(bg_color, "#C70000", 0.90),
        fg = colorscheme == 'gruvbox' and require("gruvbox.palette").colors.dark2 or utils.transparent_color(bg_color, "#2F2F2F", 0.00)
      })
      vim.api.nvim_set_hl(0, 'DiffAdd', {                 -- 追加された行
        bg = utils.transparent_color(bg_color, "#00A100", 0.85)
      })
      vim.api.nvim_set_hl(0, 'DiffChange', {              -- 変更行
        bg = utils.transparent_color(bg_color, "#B9C42F", 0.80)
      })
      vim.api.nvim_set_hl(0, 'DiffText', {                -- 変更行の変更箇所
        bg = utils.transparent_color(bg_color, "#FD7E00", 0.65)
      })
    end
    -- coc.nvim
    vim.api.nvim_set_hl(0, 'CocFadeOut', {
      bg = utils.transparent_color(bg_color, '#ADABAC', 0.50),
      fg = "LightGrey"
    })
    vim.api.nvim_set_hl(0, 'CocHintSign', { fg = "LightGrey" })
    vim.api.nvim_set_hl(0, 'CocHighlightText', {
      bg = utils.transparent_color(bg_color, "LightGrey", 0.75),
    })
    if colorscheme == 'gruvbox' then
      vim.api.nvim_set_hl(0, 'HighlightedyankRegion', {
        bg = utils.transparent_color(bg_color, "#FD7E00", 0.70)
      })
    else
      vim.api.nvim_set_hl(0, 'HighlightedyankRegion', {
        bg = utils.transparent_color(bg_color, "Magenta", 0.65),
      })
    end
    -- vim-matchup
    vim.api.nvim_set_hl(0, 'MatchParen', {
      bg = utils.transparent_color(bg_color, "LightGrey", 0.75),
      bold = true,
      underline = false
    })
    vim.api.nvim_set_hl(0, 'MatchWord', {link = "MatchParen"})
    vim.api.nvim_set_hl(0, 'MatchWordCur', {link = "MatchParen"})
  end

  local custom_highlight = vim.api.nvim_create_augroup("CustomHighlight", {})

  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = { colorscheme },
    callback = set_customcolor,
    group = custom_highlight,
  })
end
-----------------------------------------------------------------------------------
-- public
-----------------------------------------------------------------------------------
local M = {}
--
-- lualine.nvim
--
M.lua_add_lualine = function()
  -- skkeletonのモードを返す
  local function skkeleton_mode()
    local modes = {
      ["hira"]    = "あ",
      ["kata"]    = "ア",
      ["hankata"] = "ｱ",
      ["zenkaku"] = "ａ",
      ["abbrev"]  = "a",
    }
    if vim.call('skkeleton#is_enabled') then
      return modes[vim.call('skkeleton#mode')]
    else
      return ''
    end
  end

  require('lualine').setup({
    sections = {
      lualine_a = {'mode', skkeleton_mode},
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
            readonly = '',        -- Text to show when the file is non-modifiable or readonly.(\ue0a2)
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
  })
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
-- bufferline.nvim
--
M.lua_source_bufferline = function()
  local bufferline = require('bufferline')
  bufferline.setup({
    options = {
      -- mode = 'tabs',
      show_tab_indicators = true,
      buffer_close_icon = '×',
      style_preset = bufferline.style_preset.no_italic,
      numbers = function(opts)
        return string.format('%s.%s', opts.lower(opts.id), opts.lower(opts.ordinal))
      end,
      diagnostics = "coc",
      diagnostics_indicator = function(count, level)
        local icon = level:match("error") and " " or " "
        return " " .. icon .. count
      end,
    },
    highlights = {
      tab_selected = {
          fg = vim.g['colors_name'] == 'gruvbox' and '#ECE0BF' or '',
      },
    }
  })
end
--
-- dropbar.nvim
--
M.lua_source_dropbar = function()
  require('dropbar').setup({
    icons = {
      kinds = {
        use_devicons = true,
        symbols = {
          -- TODO: 上手く表示できない奴は変える
          Array = '󰅪 ',
          Boolean = ' ',
          BreakStatement = '󰙧 ',
          Call = '󰃷 ',
          CaseStatement = '󱃙 ',
          Class = ' ',
          Color = '󰏘 ',
          Constant = '󰏿 ',
          Constructor = ' ',
          ContinueStatement = '→ ',
          Copilot = ' ',
          Declaration = '󰙠 ',
          Delete = '󰩺 ',
          DoStatement = '󰑖 ',
          Enum = ' ',
          EnumMember = ' ',
          Event = ' ',
          Field = ' ',
          File = '󰈔 ',
          Folder = '󰉋 ',
          ForStatement = '󰑖 ',
          Function = '󰊕 ',
          Identifier = '󰀫 ',
          IfStatement = '󰇉 ',
          Interface = ' ',
          Keyword = '󰌋 ',
          List = '󰅪 ',
          Log = '󰦪 ',
          Lsp = ' ',
          Macro = '󰁌 ',
          MarkdownH1 = '󰉫 ',
          MarkdownH2 = '󰉬 ',
          MarkdownH3 = '󰉭 ',
          MarkdownH4 = '󰉮 ',
          MarkdownH5 = '󰉯 ',
          MarkdownH6 = '󰉰 ',
          Method = '󰆧 ',
          Module = '󰏗 ',
          Namespace = '󰅩 ',
          Null = '󰢤 ',
          Number = '󰎠 ',
          Object = '󰅩 ',
          Operator = '󰆕 ',
          Package = '󰆦 ',
          Property = ' ',
          Reference = '󰦾 ',
          Regex = ' ',
          Repeat = '󰑖 ',
          Scope = '󰅩 ',
          Snippet = '󰩫 ',
          Specifier = '󰦪 ',
          Statement = '󰅩 ',
          String = '󰉾 ',
          Struct = ' ',
          SwitchStatement = '󰺟 ',
          Text = ' ',
          Type = ' ',
          TypeParameter = '󰆩 ',
          Unit = ' ',
          Value = '󰎠 ',
          Variable = '󰀫 ',
          WhileStatement = '󰑖 ',
        },
      },
      ui = {
        bar = {
          separator = ' ',
          extends = '…',
        },
        menu = {
          separator = ' ',
          indicator = ' ',
        },
      },
    },
  })
  vim.keymap.set('n', '<space>p', require('dropbar.api').pick)
end

--
-- vim-nightfly-colors
--
M.lua_add_nightfly_colors = function()
  local bg_color = "#011627" -- :hi Normal
  custom_color(bg_color, "nightfly")
  vim.cmd [[colorscheme nightfly]]
end

--
-- gruvbox.nvim
--
M.lua_add_gruvbox = function()
  local bg_color = "#282828" -- :hi Normal
  custom_color(bg_color, "gruvbox")
  vim.o.background = "dark"
  vim.cmd [[colorscheme gruvbox]]
end

--
-- nightfox.nvim
--
M.lua_add_nightfox = function()
  local bg_color = "#192330" -- :hi Normal
  custom_color(bg_color, "nightfox")
  vim.cmd("colorscheme nightfox")
end

--
-- catppuccin.nvim
--
M.lua_add_catppuccin = function()
  local bg_color = "1e1e2e" -- :hi Normal
  custom_color(bg_color, "catppuccin-mocha")
  vim.cmd("colorscheme catppuccin")
end

--
-- satelite.nvim
--
M.lua_source_satelite = function()
  require('satellite').setup({
    current_only = false,
    winblend = 50,
    zindex = 40,
    excluded_filetypes = {},
    width = 2,
    handlers = {
      search = {
        enable = true,
      },
      diagnostic = {
        enable = true,
        signs = {'-', '=', '≡'},
        min_severity = vim.diagnostic.severity.HINT,
      },
      gitsigns = {
        enable = true,
        signs = { -- can only be a single character (multibyte is okay)
          add = "│",
          change = "│",
          delete = "-",
        },
      },
      marks = {
        enable = true,
        show_builtins = false, -- shows the builtin marks like [ ] < >
      },
    },
  })
end

return M
