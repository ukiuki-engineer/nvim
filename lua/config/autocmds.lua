local augroup = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd
local utils = require("utils")

augroup("my_vimrc", {})

-- phpのインデントは4
au("FileType", {
  group = "my_vimrc",
  pattern = {"php"},
  callback = function()
    utils.setlocal_indent(4)
  end
})

-- FIXME: markdownだけ何故かインデン4になってしまうので一旦強制的に2に。後で原因を調べる。
au("FileType", {
  group = "my_vimrc",
  pattern = {"markdown"},
  callback = function()
    utils.setlocal_indent(2)
  end
})
