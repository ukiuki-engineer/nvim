local api = vim.api
local utils = require("utils")

api.nvim_create_augroup("my_vimrc", {})

-- phpのインデントは4
api.nvim_create_autocmd("FileType", {
  group = "my_vimrc",
  pattern = {"php"},
  callback = function()
    utils.setlocal_indent(4)
  end
})

-- FIXME: markdownだけ何故かインデン4になってしまうので一旦強制的に2に。後で原因を調べる。
api.nvim_create_autocmd("FileType", {
  group = "my_vimrc",
  pattern = {"markdown"},
  callback = function()
    utils.setlocal_indent(2)
  end
})
