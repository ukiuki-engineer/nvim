local fn = vim.fn
local augroup = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

augroup("my_autocmds", {})

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
