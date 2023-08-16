-- ================================================================================
-- coding
-- ================================================================================
local M       = {}

local fn      = vim.fn
local g       = vim.g
local augroup = vim.api.nvim_create_augroup
local au      = vim.api.nvim_create_autocmd

--
-- vim-matchup
--
function M.lua_source_matchup()
  g.matchup_matchpref = {
    html  = { tagnameonly = 1 },
    xml   = { tagnameonly = 1 },
    blade = { tagnameonly = 1 },
    vue   = { tagnameonly = 1 }
  }
end

--
-- vim-commentary
--
function M.lua_source_commentary()
  augroup("my_commentstring", {})
  au("FileType", {
    group = "my_commentstring",
    pattern = { "applescript", "toml" },
    callback = function()
      vim.bo.commentstring = "# %s"
    end
  })
  au("FileType", {
    group = "my_commentstring",
    pattern = { "php", "json" },
    callback = function()
      vim.bo.commentstring = "// %s"
    end
  })
  au("FileType", {
    group = "my_commentstring",
    pattern = { "vue" },
    callback = function()
      vim.bo.commentstring = "<!-- %s -->"
    end
  })
end

--
-- vim-autoclose(自作)
--
function M.lua_source_autoclose()
  fn["plugins#hook_source_autoclose"]()
end

--
-- nvim-colorizer.lua
--
function M.lua_source_colorizer()
  augroup("my_colorizer", {})
  au("FileType", {
    group = "my_colorizer",
    pattern = {
      "blade",
      "css",
      "eruby",
      "html",
      "javascript",
      "less",
      "lua",
      "markdown",
      "sass",
      "scss",
      "stylus",
      "toml",
      "vim",
      "vue",
      "xml",
    },
    command = "ColorizerAttachToBuffer"
  })
  require("colorizer").setup()
end

--
-- skkeleton
--
-- NOTE: lua化保留
function M.lua_add_skkeleton()
  fn["plugins#hook_add_skkeleton"]()
end

-- NOTE: lua化保留
function M.lua_source_skkeleton()
  fn["plugins#hook_source_skkeleton"]()
end

--
-- nvim-cmp
--
function M.lua_source_nvim_cmp()
  local cmp = require('cmp')

  -- cmdlineのマッピング(検索/コマンド共通)
  local cmdline_mapping = cmp.mapping.preset.cmdline({
    -- 履歴の選択はデフォルト操作で
    ["<C-n>"] = cmp.mapping.scroll_docs(1),
    ["<C-p>"] = cmp.mapping.scroll_docs(-1),
  })

  -- 遅延ロードされる独自定義コマンド用のsource
  local my_source = {}
  function my_source:complete(_, callback)
    -- コマンドリストを初期化
    local my_commands = {}

    -- paste_image.vimがロードされてなければコマンドリストに追加
    if vim.g['vimrc#loaded_paste_image'] == nil then
      table.insert(my_commands, { label = 'PasteImage' })
    end

    -- my_terminal.vimがロードされてなければコマンドリストに追加
    if vim.g['vimrc#loaded_my_terminal'] == nil then
      table.insert(my_commands, { label = 'Term' })
      table.insert(my_commands, { label = 'TermV' })
      table.insert(my_commands, { label = 'TermHere' })
      table.insert(my_commands, { label = 'TermHereV' })
      table.insert(my_commands, { label = 'Terminal' })
    end

    callback(my_commands)
  end

  -- sourceを登録
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
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmdline_mapping,
    sources = {
      { name = 'buffer' }
    }
  })
  -- コマンド
  cmp.setup.cmdline({ ':' }, {
    mapping = cmdline_mapping,
    sources = { -- NOTE: cmp.config.sources({...})とすると、
      -- source同士が結合されて新しいsourceが作られるので上手くいかない
      { name = 'path' },
      { name = 'my_source' },
      { name = 'cmdline' },
    }
  })
end

return M
