-- ================================================================================
-- coding
-- ================================================================================
local fn      = vim.fn
local g       = vim.g
local augroup = vim.api.nvim_create_augroup
local au      = vim.api.nvim_create_autocmd

local M       = {}

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

    -- paste_image.luaがロードされてなければコマンドリストに追加
    if vim.g['vimrc#loaded_paste_image'] == nil then
      table.insert(my_commands, { label = 'PasteImage' })
    end

    -- terminal.luaがロードされてなければコマンドリストに追加
    if vim.g['vimrc#loaded_terminal'] == nil then
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

--
-- vim-shfmt
--
function M.lua_source_shfmt()
  -- shfmtが無ければインストール
  if fn.exepath("shfmt") == "" then
    fn.system("go install mvdan.cc/sh/v3/cmd/shfmt@latest")
  end
  g.shfmt_extra_args  = '-i 2 -ci -bn -s'
  g.shfmt_fmt_on_save = 1 -- TODO: zshとかでformat on saveが効かないような...？
end

--
-- nvim-treesitter
--
function M.lua_source_treesitter()
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
    context_commentstring = {
      enable = true,
    },
    -- ensure_installed = 'all', -- :TSInstall allと同じ
    ensure_installed = {
      "awk",
      "bash",
      "css",
      "diff",
      "dockerfile",
      "html",
      "ini",
      "java",
      "javascript",
      "jq",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "php",
      "phpdoc",
      "ruby",
      "scss",
      "sql",
      "toml",
      "typescript",
      "vim",
      "vimdoc",
      "vue",
    },
  }
  -- FIXME: 全部書かずに、追加分だけ書く事はできないのか？
  require("vim.treesitter.query").set(
    "markdown",
    "highlights",
    [[
      ;From nvim-treesitter/nvim-treesitter
      (atx_heading (inline) @text.title)
      (setext_heading (paragraph) @text.title)

      [
        (atx_h1_marker)
        (atx_h2_marker)
        (atx_h3_marker)
        (atx_h4_marker)
        (atx_h5_marker)
        (atx_h6_marker)
        (setext_h1_underline)
        (setext_h2_underline)
      ] @punctuation.special

      [
        (link_title)
        (indented_code_block)
        (fenced_code_block)
      ] @text.literal

      [
        (fenced_code_block_delimiter)
      ] @punctuation.delimiter

      (code_fence_content) @none

      [
        (link_destination)
      ] @text.uri

      [
        (link_label)
      ] @text.reference

      [
        (list_marker_plus)
        (list_marker_minus)
        (list_marker_star)
        (list_marker_dot)
        (list_marker_parenthesis)
        (thematic_break)
      ] @punctuation.special

      [
        (block_continuation)
        (block_quote_marker)
      ] @punctuation.special

      [
        (backslash_escape)
      ] @string.escape
      ; 引用はコメントと同じ色に
      (block_quote) @comment
    ]]
  )
end

--
-- indent-blankline.nvim
--
function M.lua_source_indent_blankline()
  require("ibl").setup()
end

--
-- nvim-colorizer.lua
--
function M.lua_source_colorizer()
  require("colorizer").setup({
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
    "text",
    "toml",
    "vim",
    "vue",
    "xml",
  })
end

return M
