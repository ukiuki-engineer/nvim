-- ---------------------------------------------------------------------------
-- coc.nvimの設定
-- ---------------------------------------------------------------------------
-- NOTE: coc-bladeは、"b:xxx"と打つと補完候補が出る
-- NOTE: スペルチェッカーの辞書登録
-- .config/nvim/coc-settings.jsonの"cSpell.userWords"に追加
--   :CocCommand cSpell.addWordToUserDictionary
-- ./.vim/coc-settings.jsonの"cSpell.ignoreWords"に追加
--   :CocCommand cSpell.addIgnoreWordToWorkspace
-- NOTE: Laravel固有のメソッドに対して補完やホバーを行うには、補完ヘルパーファイルを出力する必要がある
-- 手順は以下の通り
-- composer require --dev barryvdh/laravel-ide-helper # ライブラリをインストール
-- composer require barryvdh/laravel-ide-helper:*     # ↑で上手くいかなかった場合
-- php artisan ide-helper:generate                    # _ide_helper.phpを生成
-- php artisan ide-helper:models --nowrite            # _ide_helper_models.phpを生成

local M = {}


function M.lua_source()
  local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }

  -- ---------------------------------------------------------------------------
  -- 補完周り
  vim.keymap.set("i", "<TAB>", [[
    coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()
  ]], opts)
  vim.keymap.set("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
  -- 補完候補の決定
  vim.keymap.set("i", "<cr>", [[
    coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
  ]], opts)

  -- diagnosticへのジャンプ
  -- ---------------------------------------------------------------------------
  vim.keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
  vim.keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

  -- ---------------------------------------------------------------------------
  -- 定義ジャンプ系
  vim.keymap.set("n", "gd", "<Plug>(coc-definition)", { silent = true })
  vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
  vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", { silent = true })
  vim.keymap.set("n", "gr", "<Plug>(coc-references)", { silent = true })

  -- ---------------------------------------------------------------------------
  -- hover表示
  vim.keymap.set("n", "K", function()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
      vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
      vim.fn.CocActionAsync('doHover')
    else
      vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
  end, { silent = true })

  -- ---------------------------------------------------------------------------
  -- カーソル位置のsymbolをハイライト(*でカーソル位置を検索するノリ。shiftがspaceに変わっただけ。)
  vim.keymap.set("n", "<space>8", function()
    vim.fn["CocActionAsync"]('highlight')
  end, { silent = true })
  -- 上記をダブルクリックでもできるように
  vim.keymap.set('n', '<2-LeftMouse>', function()
    vim.fn.CocActionAsync('highlight')
  end, { silent = true })

  -- ---------------------------------------------------------------------------
  -- coc-outlineの操作

  -- coc-outlineを表示
  vim.keymap.set('n', '<space>o', function()
    -- coc#window#find 関数を呼び出し、'cocViewId', 'OUTLINE' に基づいてウィンドウIDを取得
    local winid = vim.fn['coc#window#find']('cocViewId', 'OUTLINE')
    if winid == -1 then
      -- ウィンドウが見つからない場合、coc-outlineを表示
      vim.fn.CocActionAsync('showOutline', 1)
    else
      -- ウィンドウが既に存在する場合、そのウィンドウを閉じる
      vim.fn['coc#window#close'](winid)
    end
  end, { silent = true, nowait = true })

  -- coc-outlineにジャンプ
  -- NOTE:
  --   - ジャンプ前の箇所に戻るには、普通に<C-o>で
  --   - outline tree上で<space>tで、treeの開閉ができる
  vim.keymap.set('n', '<space>t', function()
    vim.fn.CocActionAsync('showOutline')
  end, { silent = true, nowait = true })
  -- ---------------------------------------------------------------------------
  -- Symbol renaming
  vim.keymap.set("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })

  -- ---------------------------------------------------------------------------
  -- float windowの操作
  -- Normal mode
  vim.keymap.set('n', '<C-j>', [[
    coc#float#has_scroll() ? coc#float#scroll(1, 1) : <Plug>(edgemotion-j)
  ]], opts)
  vim.keymap.set('n', '<C-k>', [[
    coc#float#has_scroll() ? coc#float#scroll(0, 1) : <Plug>(edgemotion-k)
  ]], opts)
  vim.keymap.set('n', '<C-f>', [[
    coc#float#has_scroll() ? coc#float#scroll(1) : '<C-f>'
  ]], opts)
  vim.keymap.set('n', '<C-b>', [[
    coc#float#has_scroll() ? coc#float#scroll(0) : '<C-b>'
  ]], opts)

  -- Insert mode
  vim.keymap.set('i', '<C-i>', [[
    coc#float#has_scroll() ? '<C-R>=coc#float#scroll(1, 1)<CR>' : '<Right>'
  ]], opts)
  vim.keymap.set('i', '<C-f>', [[
    coc#float#has_scroll() ? '<C-R>=coc#float#scroll(1)<CR>' : '<Right>'
  ]], opts)
  vim.keymap.set('i', '<C-k>', [[
    coc#float#has_scroll() ? '<C-R>=coc#float#scroll(0, 1)<CR>' : '<Left>'
  ]], opts)
  vim.keymap.set('i', '<C-b>', [[
    coc#float#has_scroll() ? '<C-R>=coc#float#scroll(0)<CR>' : '<Left>'
  ]], opts)

  -- Special handling for space + j in Normal mode
  vim.keymap.set('n', '<space>j', [[
    coc#float#has_float() ? '<Plug>(coc-float-jump)' : '<space>j'
  ]], opts)

  -- outlineを表示
  vim.api.nvim_create_user_command('CocOutlines', 'CocCommand fzf-preview.CocOutline', {})
  -- フォーマッターを呼び出す
  vim.api.nvim_create_user_command('Format', [[call CocAction('format')]], {})
  -- 辞書登録(workspace/.vim/coc-settings.jsonに追加)
  -- NOTE: 主に業務のプロジェクト用
  vim.api.nvim_create_user_command('CocAddIgnoreWordToWorkspace', 'CocCommand cSpell.addIgnoreWordToWorkspace', {})
  -- 辞書登録(~/.config/nvim/coc-settings.jsonに追加)
  -- NOTE: 業務のプロジェクト固有ワード以外は全部これで良いかも
  vim.api.nvim_create_user_command('CocAddWordToUserDictionary', 'CocCommand cSpell.addWordToUserDictionary', {})
end

return M
