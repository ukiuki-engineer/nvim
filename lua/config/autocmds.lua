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

-- カラースキームを変更するごとに良い感じに配色をセットし直す
au("ColorScheme", {
  callback = function()
    -- "normal" ハイライトグループの情報を取得
    local highlight_info = vim.fn.execute('hi normal')
    -- guibg の値を取得
    local guibg          = string.match(highlight_info, "guibg=(#%x+)")

    -- ハイライト設定を適用
    require("plugins.colorscheme").set_customcolor(guibg, vim.g.colors_name)
  end,
  group = "MyAutocmds",
})
