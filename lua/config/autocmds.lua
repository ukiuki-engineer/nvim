-------------------------------------------------------------------------------
-- autocmds
-- →大体、個々の設定のとこで定義する事が多いからここに書く事はあんまり無い
-------------------------------------------------------------------------------
local fn = vim.fn
local augroup = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

augroup("MyAutocmds", {})

-- Session.vimを保存
local pwd_in_startup = fn.expand('$PWD')
local mksession = 'mksession! ' .. pwd_in_startup .. '/Session.vim'
au({ "BufWrite", "WinLeave", "WinClosed" }, {
  group = "MyAutocmds",
  callback = function()
    -- commit編集時はスキップ
    if fn.expand('%:t') == "COMMIT_EDITMSG" then
      return
    end

    vim.cmd(mksession)
  end
})

-- git情報を更新
au("BufWrite", {
  group = "MyAutocmds",
  callback = function()
    vim.fn["utils#refresh_git_infomations"]()
  end
})
