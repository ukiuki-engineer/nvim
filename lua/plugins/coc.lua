local M       = {}

local fn      = vim.fn
local g       = vim.g
local command = vim.api.nvim_create_user_command

-- FIXME: bladeでも、phpの関数のhoverが読みたい
-- NOTE: coc-bladeは、"b:xxx"と打つと補完候補が出る
-- NOTE: :CocCommand xx.xxで各拡張機能のコマンドを色々呼び出せる
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
function M.lua_add_coc()
  -- coc-extensions
  g.coc_global_extensions = {
    '@yaegassy/coc-intelephense',
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
    'coc-yank',
  }
  command('PreviewCocOutline', ':CocCommand fzf-preview.CocOutlie', {})
  command('ProjectFiles', ':CocCommand fzf-preview.ProjectFiles', {})
  command('Changes', ':CocCommand fzf-preview.Changes', {})
end

-- NOTE: これはvimscriptで書いた方が可読性高い気がするのでlua化はしない
function M.lua_source_coc()
  fn["plugins#hook_source_coc"]()
end

return M
