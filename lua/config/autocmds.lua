-------------------------------------------------------------------------------
-- autocmds
-- →大体、個々の設定のとこで定義する事が多いからここに書く事はあんまり無い
-------------------------------------------------------------------------------
local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local fn = vim.fn

augroup("MyAutocmds", {})

-- Session.vimを保存
local pwd_in_startup = fn.expand('$PWD')
local mksession = 'mksession! ' .. pwd_in_startup .. '/Session.vim'
au({ "BufWrite", "BufRead" }, {
  group = "MyAutocmds",
  callback = function()
    -- readonlyなら何もしない
    if vim.o.readonly then
      return
    end

    -- commit編集時は何もしない
    if fn.expand('%:t') == "COMMIT_EDITMSG" then
      return
    end

    -- quickfix windowの時は何もしない
    if vim.o.filetype == "qf" then
      return
    end

    -- diffviewのパネルがあったら何もしない
    if string.find(fn.join(fn.gettabinfo(), ', '), 'diffview_view') then -- FIXME: なんか上手くいなない
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

-- env系はshとして開く
au("BufRead", {
  group = "MyAutocmds",
  pattern = { ".env", ".env.*" },
  command = "set ft=sh",
})
