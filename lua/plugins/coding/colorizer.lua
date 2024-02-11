local M = {}

function M.lua_source()
  vim.o.termguicolors = true
  require("colorizer").setup({
    "blade",
    css = { css = true, rgb_fn = true },
    "eruby",
    "html",
    "javascript",
    "less",
    "lua",
    "markdown",
    "sass",
    scss = { css = true, rgb_fn = true },
    "stylus",
    "text",
    "toml",
    "vim",
    "vue",
    "xml",
  })
end

return M
