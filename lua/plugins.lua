-- ================================================================================
-- 各プラグインの設定(lua)
-- NOTE: 関数の命名規則
-- - "hookの種類_プラグイン名"とする
-- - ハイフンはアンダーバーに変更
-- - 以下は省略する。ただし、省略するとわかりづらい場合は除く。
--   - "vim-"
--   - "nvim-"
--   - ".vim"
--   - ".nvim"
--   - ".lua"
-- ================================================================================
local M = {}
-- ================================================================================
-- UI
-- ================================================================================
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

  local utils = require("utils")
  local bg_color = "#011627" -- :hi Normal


  local function fix_nightfly()
    -- diffview
    vim.api.nvim_set_hl(0, 'DiffviewDiffAddAsDelete', { -- NOTE: 不明
      bg = "#FF0000"
    })
    vim.api.nvim_set_hl(0, 'DiffDelete', {              -- 削除された行
      bg = utils.transparent_color(bg_color, "#C70000", 0.90)
    })
    vim.api.nvim_set_hl(0, 'DiffviewDiffDelete', {      -- 行が追加された場合の左側
      bg = utils.transparent_color(bg_color, "#C70000", 0.90),
      fg = utils.transparent_color(bg_color, "#2F2F2F", 0.00)
    })
    vim.api.nvim_set_hl(0, 'DiffAdd', {                 -- 追加された行
      bg = utils.transparent_color(bg_color, "#00A100", 0.85)
    })
    vim.api.nvim_set_hl(0, 'DiffChange', {              -- 変更行
      bg = utils.transparent_color(bg_color, "#B9C42F", 0.90)
    })
    vim.api.nvim_set_hl(0, 'DiffText', {                -- 変更行の変更箇所
      bg = utils.transparent_color(bg_color, "#FD7E00", 0.70)
    })
    -- coc.nvim
    vim.api.nvim_set_hl(0, 'CocFadeOut', {
      bg = utils.transparent_color(bg_color, '#ADABAC', 0.50),
      fg = "LightGrey"
    })
    vim.api.nvim_set_hl(0, 'CocHintSign', { fg = "LightGrey" })
    vim.api.nvim_set_hl(0, 'CocHighlightText', {
      bg = utils.transparent_color(bg_color, "LightGrey", 0.75),
    })
    -- vim-matchup
    vim.api.nvim_set_hl(0, 'MatchParen', {
      bg = utils.transparent_color(bg_color, "LightGrey", 0.75),
      bold = true,
      underline = true
    })
    vim.api.nvim_set_hl(0, 'MatchWord', {link = "MatchParen"})
    vim.api.nvim_set_hl(0, 'MatchWordCur', {link = "MatchParen"})
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
  local utils = require("utils")
  local bg_color = "#282828" -- :hi Normal

  -- ハイライト色を色々と変更
  local function fix_gruvbox()
    -- diffview
    vim.api.nvim_set_hl(0, 'DiffviewDiffAddAsDelete', { -- NOTE: 不明
      bg = "#FF0000"
    })
    vim.api.nvim_set_hl(0, 'DiffDelete', {              -- 削除された行
      bg = utils.transparent_color(bg_color, "#C70000", 0.90)
    })
    vim.api.nvim_set_hl(0, 'DiffviewDiffDelete', {      -- 行が追加された場合の左側
      bg = utils.transparent_color(bg_color, "#C70000", 0.90),
      fg = colors.dark2
    })
    vim.api.nvim_set_hl(0, 'DiffAdd', {                 -- 追加された行
      bg = utils.transparent_color(bg_color, "#009900", 0.85)
    })
    vim.api.nvim_set_hl(0, 'DiffChange', {              -- 変更行
      bg = utils.transparent_color(bg_color, "#B9C42F", 0.90)
    })
    vim.api.nvim_set_hl(0, 'DiffText', {                -- 変更行の変更箇所
      bg = utils.transparent_color(bg_color, "#FD7E00", 0.70)
    })
    -- coc.nvim
    vim.api.nvim_set_hl(0, 'CocFadeOut', {
      bg = utils.transparent_color(bg_color, '#ADABAC', 0.50),
      fg = "LightGrey"
    })
    vim.api.nvim_set_hl(0, 'CocHintSign', { fg = "LightGrey" })
    vim.api.nvim_set_hl(0, 'CocHighlightText', {
      bg = utils.transparent_color(bg_color, "LightGrey", 0.75),
    })
    -- vim-matchup
    vim.api.nvim_set_hl(0, 'MatchParen', {
      bg = utils.transparent_color(bg_color, "LightGrey", 0.75),
      bold = true,
      underline = true
    })
    -- 検索
    vim.api.nvim_set_hl(0, 'Search', {
      bg = utils.transparent_color(bg_color, "#FABD2F", 0.70),
    })
    -- vim.api.nvim_set_hl(0, 'CurSearch', {
      -- bg = utils.transparent_color(bg_color, "#FE8019", 0.35),
      -- bg = utils.transparent_color(bg_color, "#FABD2F", 0.50),
    -- })
    vim.api.nvim_set_hl(0, 'IncSearch', {
      -- bg = utils.transparent_color(bg_color, "#FE8019", 0.35),
      bg = utils.transparent_color(bg_color, "#FABD2F", 0.50),
    })
  end

  local custom_highlight = vim.api.nvim_create_augroup("CustomHighlight", {})

  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = {"gruvbox"},
    callback = fix_gruvbox,
    group = custom_highlight,
  })
  vim.o.background = "dark"
  vim.cmd [[colorscheme gruvbox]]
end
-- ================================================================================
-- Code Editting
-- ================================================================================
--
-- indent-blankline.nvim
--
M.lua_source_indent_blankline = function()
  vim.opt.list = true
  vim.opt.listchars:append({
    space = "⋅",
    tab = "»-",
    trail = "-",
    eol = "↓",
    extends = "»",
    precedes = "«",
    nbsp = "%"
  })
  require("indent_blankline").setup {
    show_end_of_line = true,
    space_char_blankline = " "
  }
end
-- ================================================================================
-- LSP and Completion
-- ================================================================================
--
-- nvim-cmp
--
M.lua_source_nvim_cmp = function()
  local cmp = require('cmp')
  -- cmdlineのマッピング(検索/コマンド共通)
  local cmdline_mapping = cmp.mapping.preset.cmdline({
    -- 履歴の選択はデフォルト操作で
    ["<C-n>"] = cmp.mapping.scroll_docs(1),
    ["<C-p>"] = cmp.mapping.scroll_docs(-1),
    -- 補完候補の選択は<C-j>, <C-k>で
    -- ['<C-j>'] = cmp.mapping({
    --   c = function(fallback)
    --     if cmp.visible() then
    --       return cmp.select_next_item()
    --     end
    --     fallback()
    --   end,
    -- }),
    -- ['<C-k>'] = cmp.mapping({
    --   c = function(fallback)
    --     if cmp.visible() then
    --       return cmp.select_prev_item()
    --     end
    --     fallback()
    --   end,
    -- }),
  })
  -- 遅延ロードされる独自定義コマンド用のsource
  local my_source = {}
  function my_source:complete(_, callback)
    callback({
      { label = 'Term' },
      { label = 'TermV' },
      { label = 'TermHere' },
      { label = 'TermHereV' },
      { label = 'Terminal' },
    })
  end
  cmp.register_source('my_source', my_source)
  cmp.setup({
    -- skkeleton {{{
    mapping = cmp.mapping.preset.insert({
      ['<Tab>'] = cmp.mapping({
        i = function(fallback)
          if cmp.visible() then
            return cmp.select_next_item()
          end
          fallback()
        end,
      }),
      ['<S-Tab>'] = cmp.mapping({
        i = function(fallback)
          if cmp.visible() then
            return cmp.select_prev_item()
          end
          fallback()
        end,
      }),
    }),
    sources = cmp.config.sources({
      { name = 'skkeleton' },
    }),
    -- }}}
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
  })
  -- 検索
  cmp.setup.cmdline({'/', '?'}, {
    mapping = cmdline_mapping,
    sources = {
      { name = 'buffer' }
    }
  })
  -- コマンド
  cmp.setup.cmdline({':'}, {
    mapping = cmdline_mapping,
    sources = {
      { name = 'path' },
      { name = 'my_source' },
      { name = 'cmdline' },
    }
    -- NOTE: 以下の書き方だと、source同士が結合されて新しいsourceが作られるらしい。
    --       以下の書き方だとmy_sourceの一部が上手く補完されなかった。
    -- sources = cmp.config.sources({
    --   { name = 'path' },
    -- }, {
    --   { name = 'cmdline' }
    -- }, {
    --   { name = 'my_source' }
    -- })
  })
end
-- ================================================================================
-- Git
-- ================================================================================
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

-- ================================================================================
-- Others
-- ================================================================================
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

return M