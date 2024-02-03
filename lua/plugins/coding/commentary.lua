local augroup = vim.api.nvim_create_augroup
local au      = vim.api.nvim_create_autocmd

local M       = {}

function M.lua_source()
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

return M
