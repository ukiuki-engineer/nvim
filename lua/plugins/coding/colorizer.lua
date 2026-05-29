local M = {}

function M.lua_source()
  vim.o.termguicolors = true
  require("colorizer").setup({
    "blade",
    "eruby",
    "html",
    "javascript",
    "less",
    "lua",
    "markdown",
    "sass",
    "stylus",
    "text",
    "toml",
    "typescriptreact",
    "vim",
    "vue",
    "xml",
    css = { css = true, rgb_fn = true },
    scss = { css = true, rgb_fn = true },
  })
end

return M
