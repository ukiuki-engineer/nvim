local M = {}

function M.lua_source()
  vim.o.termguicolors = true
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
