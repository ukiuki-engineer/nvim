-------------------------------------------------------------------------------
-- autocmds
-- →大体、個々の設定のとこで定義する事が多いからここに書く事はあんまり無い
-------------------------------------------------------------------------------
local fn = vim.fn
local augroup = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

augroup("MyAutocmds", {})

-- 保存時にSession.vimを書き込む
local pwd_in_startup = fn.expand('$PWD')
local mksession = 'mksession! ' .. pwd_in_startup .. '/Session.vim'
au("BufWrite", {
  group = "MyAutocmds",
  callback = function()
    -- commit編集時はスキップ
    if fn.expand('%:t') == "COMMIT_EDITMSG" then
      return
    end

    vim.cmd(mksession)
    vim.fn["utils#refresh_git_infomations"]()
  end
})
