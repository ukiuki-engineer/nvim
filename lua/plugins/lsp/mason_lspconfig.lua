--
-- NOTE: まだ全然使ってない。普段はcoc.nvimを使用
-- これからぼちぼち設定整えていく予定...
--

local M = {}

function M.lua_source_mason_lspconfig()
  require("mason-lspconfig").setup({
    ensure_installed = {
      "lua_ls",
    },
  })
end

function M.lua_source_mason_null_ls()
  -- TODO: 作業中
  local mason_null_ls = require('mason-null-ls')
  mason_null_ls.setup({
    ensure_installed = {
      { 'stylua', version = 'v0.14.2' },
    },
    automatic_installation = true,
  })
  mason_null_ls.check_install(true)
end

function M.lua_source_mason()
  -- NOTE: 事前インストール
  -- brew install luarocks
  require("mason").setup()
end

function M.lua_source_lspconfig()
  require("lspconfig").lua_ls.setup({})
end

function M.lua_source_null_ls()
  local null_ls = require("null-ls")
  null_ls.setup({
    null_ls.builtins.formatting.stylua,    -- lua formatter
    null_ls.builtins.diagnostics.luacheck, -- lua linter
  })
end

return M
