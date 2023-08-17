-- ================================================================================
-- Others
-- ================================================================================
local g      = vim.g
local fn     = vim.fn
local keyset = vim.keymap.set
local opts   = { noremap = true, silent = true }

local M      = {}

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
  vim.opt.list = true
  vim.opt.listchars:append({
    space    = "⋅",
    tab      = "»-",
    trail    = "-",
    eol      = "↓",
    extends  = "»",
    precedes = "«",
    nbsp     = "%"
  })
  require("indent_blankline").setup {
    show_end_of_line     = true,
    space_char_blankline = " "
  }
end

--
-- vim-quickrun
--
function M.lua_add_quickrun()
  keyset({ "n", "x" }, "<F5>", ":QuickRun<CR>", opts)
end

--
-- vimhelpgenerator
--
function M.lua_source_vimhelpgenerator()
  g.vimhelpgenerator_defaultlanguage = 'ja'
  g.vimhelpgenerator_version = ''
  g.vimhelpgenerator_author = 'Author  : ukiuki-engineer'
  g.vimhelpgenerator_contents = {
    contents         = 1,
    introduction     = 1,
    usage            = 1,
    interface        = 1,
    variables        = 1,
    commands         = 1,
    ["key-mappings"] = 1,
    functions        = 1,
    setting          = 0,
    todo             = 1,
    changelog        = 0
  }
end

--
-- previm
--
function M.lua_source_previm()
  -- fn["plugins#hook_source_previm"]()
  g.previm_show_header = 1
  g.previm_enable_realtime = 1
  if fn.has('mac') then
    -- MacOS用
    g.previm_open_cmd = [[open -a Google\ Chrome]]
  elseif fn.has('linux') and fn.exists('$WSLENV') then
    -- TODO: WSL用
  end
end

--
-- toggleterm.nvim
-- FIXME: <C-w>L<C-w>Jとするとサイズがバグる
--
function M.lua_add_toggleterm()
  keyset("t", "<C-`>", "<Cmd>ToggleTerm<CR>")
  keyset("n", "<C-`>", ":ToggleTerm<CR>")
end

function M.lua_source_toggleterm()
  require("toggleterm").setup {
    persist_size = false
  }
  -- カレントバッファのディレクトリでterminalを開く
  vim.cmd([[command! ToggleTermHere ToggleTerm dir=%:h]])
end

return M
