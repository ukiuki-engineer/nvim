local fn = vim.fn
local augroup = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd
local utils = require("utils")

augroup("my_autocmds", {})

-- phpのインデントは4
au("FileType", {
  group = "my_autocmds",
  pattern = { "php" },
  callback = function()
    utils.setlocal_indent(4)
  end
})

-- FIXME: markdownだけ何故かインデン4になってしまうので一旦強制的に2に。後で原因を調べる。
au("FileType", {
  group = "my_autocmds",
  pattern = { "markdown" },
  callback = function()
    utils.setlocal_indent(2)
  end
})

-- 保存時にSession.vimを書き込む
local pwd_in_startup = fn.expand('$PWD')
local mksession = 'mksession! ' .. pwd_in_startup .. '/Session.vim'
au("BufWrite", {
  group = "my_autocmds",
  callback = function()
    if fn.expand('%:t') == "COMMIT_EDITMSG" then
      return
    end
    vim.cmd(mksession)
  end
})
