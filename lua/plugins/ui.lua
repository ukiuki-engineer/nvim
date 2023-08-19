-- ================================================================================
-- UI
-- ================================================================================
local keyset = vim.keymap.set

local M = {}

--
-- lualine.nvim
--
function M.lua_add_lualine()
  -- skkeletonのモードを返す
  local function skkeleton_mode()
    local modes = {
      ["hira"]    = "あ",
      ["kata"]    = "ア",
      ["hankata"] = "ｱ",
      ["zenkaku"] = "ａ",
      ["abbrev"]  = "a",
    }
    if vim.fn['skkeleton#is_enabled']() then
      return modes[vim.fn['skkeleton#mode']()]
    else
      return ''
    end
  end

  local function commit_status()
    if not vim.fn['utils#is_git_project']() then
      return ""
    end

    local number = vim.fn['utils#get_commit_status'](true)
    return "󰑓 ↓" .. number['remote'] .. " ↑" .. number['local']
  end

  require('lualine').setup({
    sections = {
      lualine_a = { 'mode', skkeleton_mode },
      lualine_b = { 'branch', commit_status, 'diff', 'diagnostics' },
      -- lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = {
        {
          'filename',
          file_status = true,     -- Displays file status (readonly status, modified status)
          newfile_status = false, -- Display new file status (new file means no write after created)
          path = 1,               -- 0: Just the filename
          -- 1: Relative path
          -- 2: Absolute path
          -- 3: Absolute path, with tilde as the home directory
          -- 4: Filename and parent dir, with tilde as the home directory
          shorting_target = 40, -- Shortens path to leave 40 spaces in the window
          -- for other components. (terrible name, any suggestions?)
          symbols = {
            modified = '[+]',      -- Text to show when the file is modified.
            readonly = '',      -- Text to show when the file is non-modifiable or readonly.(\ue0a2)
            unnamed = '[No Name]', -- Text to show for unnamed buffers.
            newfile = '[New]',     -- Text to show for newly created file before first write
          }
        }
      },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        {
          'filename',
          file_status = true,     -- Displays file status (readonly status, modified status)
          newfile_status = false, -- Display new file status (new file means no write after created)
          path = 1,               -- 0: Just the filename
          -- 1: Relative path
          -- 2: Absolute path
          -- 3: Absolute path, with tilde as the home directory
          -- 4: Filename and parent dir, with tilde as the home directory
          shorting_target = 40, -- Shortens path to leave 40 spaces in the window
          -- for other components. (terrible name, any suggestions?)
          symbols = {
            modified = '[+]',      -- Text to show when the file is modified.
            readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
            unnamed = '[No Name]', -- Text to show for unnamed buffers.
            newfile = '[New]',     -- Text to show for newly created file before first write
          }
        }
      },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {}
    },
  })
end

--
-- nvim-tree
--
function M.lua_add_nvim_tree()
  keyset('n', '<C-n>', "<Cmd>NvimTreeToggle<CR>", {})
  keyset('n', '<C-w>t', "<Cmd>NvimTreeFindFile<CR>", {})
end

function M.lua_source_nvim_tree()
  require("nvim-tree").setup {
    git = {
      ignore = false, -- .gitignoreされたファイルもtreeに表示する
    },
    -- 以下、treeのrootに関する設定
    -- prefer_startup_root = true,
    sync_root_with_cwd = true, -- `:cd`, `:tcd`と同期
    update_focused_file = {
      enable = false,          -- カレントバッファに合わせて常に更新
      update_root = true,      -- `:NvimTreeFindFile`すると更新
      ignore_list = {},
    },
    view = {
      -- sizeを動的に調整する
      width = {
        min = 5,
        max = 75,
        padding = 1
      }
    },
  }
end

--
-- bufferline.nvim
--
function M.lua_source_bufferline()
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
function M.lua_source_dropbar()
  require('dropbar').setup({
    icons = {
      kinds = {
        use_devicons = true,
        symbols = {
          -- NOTE: 上手く表示できない奴は適宜変える
          Array             = '󰅪 ',
          Boolean           = ' ',
          BreakStatement    = '󰙧 ',
          Call              = '󰃷 ',
          CaseStatement     = '󱃙 ',
          Class             = ' ',
          Color             = '󰏘 ',
          Constant          = '󰏿 ',
          Constructor       = ' ',
          ContinueStatement = '→ ',
          Copilot           = ' ',
          Declaration       = '󰙠 ',
          Delete            = '󰩺 ',
          DoStatement       = '󰑖 ',
          Enum              = ' ',
          EnumMember        = ' ',
          Event             = ' ',
          Field             = ' ',
          File              = '󰈔 ',
          Folder            = '󰉋 ',
          ForStatement      = '󰑖 ',
          Function          = '󰊕 ',
          Identifier        = '󰀫 ',
          IfStatement       = '󰇉 ',
          Interface         = ' ',
          Keyword           = '󰌋 ',
          List              = '󰅪 ',
          Log               = '󰦪 ',
          Lsp               = ' ',
          Macro             = '󰁌 ',
          MarkdownH1        = '󰉫 ',
          MarkdownH2        = '󰉬 ',
          MarkdownH3        = '󰉭 ',
          MarkdownH4        = '󰉮 ',
          MarkdownH5        = '󰉯 ',
          MarkdownH6        = '󰉰 ',
          Method            = '󰆧 ',
          Module            = '󰏗 ',
          Namespace         = '󰅩 ',
          Null              = '󰢤 ',
          Number            = '󰎠 ',
          Object            = '󰅩 ',
          Operator          = '󰆕 ',
          Package           = '󰆦 ',
          Property          = ' ',
          Reference         = '󰦾 ',
          Regex             = ' ',
          Repeat            = '󰑖 ',
          Scope             = '󰅩 ',
          Snippet           = '󰩫 ',
          Specifier         = '󰦪 ',
          Statement         = '󰅩 ',
          String            = '󰉾 ',
          Struct            = ' ',
          SwitchStatement   = '󰺟 ',
          Text              = ' ',
          Type              = ' ',
          TypeParameter     = '󰆩 ',
          Unit              = ' ',
          Value             = '󰎠 ',
          Variable          = '󰀫 ',
          WhileStatement    = '󰑖 ',
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
  keyset('n', '<space>p', require('dropbar.api').pick)
end

--
-- satellite.nvim
--
function M.lua_source_satellite()
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
        signs = { '-', '=', '≡' },
        min_severity = vim.diagnostic.severity.HINT,
      },
      gitsigns = {
        enable = true,
        signs = {
          -- can only be a single character (multibyte is okay)
          add = "│",
          change = "│",
          delete = "-",
        },
      },
      marks = {
        enable = true,
        show_builtins = true, -- shows the builtin marks like [ ] < >
      },
    },
  })
end

return M
