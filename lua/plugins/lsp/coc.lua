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

function M.lua_add()
  -- coc-extensions
  vim.g.coc_global_extensions = {
    '@yaegassy/coc-intelephense',
    '@yaegassy/coc-marksman',
    -- '@yaegassy/coc-laravel',
    'coc-blade',
    'coc-css',
    'coc-cssmodules',
    'coc-docker',
    'coc-eslint',
    'coc-fzf-preview',
    'coc-html',
    'coc-jedi',
    'coc-json',
    'coc-lua',
    'coc-php-cs-fixer',
    'coc-prettier',
    'coc-sh',
    'coc-snippets',
    'coc-solargraph',
    'coc-spell-checker',
    'coc-sql',
    'coc-tsserver',
    'coc-vetur',
    'coc-vimlsp',
    'coc-word',
    'coc-xml',
    'coc-yaml',
  }
  vim.api.nvim_create_user_command('CocOutlines', 'CocCommand fzf-preview.CocOutline', {})
end

function M.lua_source()
  local keyset = vim.keymap.set
  local opts   = { silent = true, noremap = true, expr = true, replace_keycodes = false }

  -- ---------------------------------------------------------------------------
  -- 補完周り
  keyset("i", "<TAB>", [[
    coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()
  ]], opts)
  keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
  -- 補完候補の決定
  keyset("i", "<cr>", [[
    coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
  ]], opts)

  -- ---------------------------------------------------------------------------
  -- 定義ジャンプ系
  keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
  keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
  keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
  keyset("n", "gr", "<Plug>(coc-references)", { silent = true })

  -- ---------------------------------------------------------------------------
  -- hover表示
  keyset("n", "K", function()
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
  keyset("n", "<space>8", function()
    vim.fn["CocActionAsync"]('highlight')
  end, { silent = true })
  -- 上記をダブルクリックでもできるように
  keyset('n', '<2-LeftMouse>', function()
    vim.fn.CocActionAsync('highlight')
  end, { silent = true })

  -- ---------------------------------------------------------------------------
  -- coc-outlineの操作
  -- coc-outlineを表示
  keyset('n', '<space>o', function()
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
  -- NOTE: ジャンプ前の箇所に戻るには、普通に<C-o>で
  vim.keymap.set('n', '<space>t', function()
    vim.fn.CocActionAsync('showOutline')
  end, { silent = true, nowait = true })

  -- ---------------------------------------------------------------------------
  -- Symbol renaming
  keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })

  -- ---------------------------------------------------------------------------
  -- float windowの操作
  -- Normal mode
  keyset('n', '<C-j>', [[
    coc#float#has_scroll() ? coc#float#scroll(1, 1) : '7j'
  ]], opts)
  keyset('n', '<C-k>', [[
    coc#float#has_scroll() ? coc#float#scroll(0, 1) : '7k'
  ]], opts)
  keyset('n', '<C-f>', [[
    coc#float#has_scroll() ? coc#float#scroll(1) : '<C-f>'
  ]], opts)
  keyset('n', '<C-b>', [[
    coc#float#has_scroll() ? coc#float#scroll(0) : '<C-b>'
  ]], opts)

  -- Insert mode
  keyset('i', '<C-i>', [[
    coc#float#has_scroll() ? '<C-R>=coc#float#scroll(1, 1)<CR>' : '<Right>'
  ]], opts)
  keyset('i', '<C-f>', [[
    coc#float#has_scroll() ? '<C-R>=coc#float#scroll(1)<CR>' : '<Right>'
  ]], opts)
  keyset('i', '<C-k>', [[
    coc#float#has_scroll() ? '<C-R>=coc#float#scroll(0, 1)<CR>' : '<Left>'
  ]], opts)
  keyset('i', '<C-b>', [[
    coc#float#has_scroll() ? '<C-R>=coc#float#scroll(0)<CR>' : '<Left>'
  ]], opts)

  -- Special handling for space + j in Normal mode
  keyset('n', '<space>j', [[
    coc#float#has_float() ? '<Plug>(coc-float-jump)' : '<space>j'
  ]], opts)

  -- フォーマッターを呼び出す
  vim.api.nvim_create_user_command('Format', [[call CocAction('format')]], {})
end

return M
