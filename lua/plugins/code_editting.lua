-- ================================================================================
-- Code Editting
-- ================================================================================
local M = {}
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

return M
