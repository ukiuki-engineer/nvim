-- ================================================================================
-- LSP and Completion
-- ================================================================================
local M = {}
--
-- nvim-cmp
--
M.lua_source_nvim_cmp = function()
  local cmp = require('cmp')
  -- cmdlineのマッピング(検索/コマンド共通)
  local cmdline_mapping = cmp.mapping.preset.cmdline({
    -- 履歴の選択はデフォルト操作で
    ["<C-n>"] = cmp.mapping.scroll_docs(1),
    ["<C-p>"] = cmp.mapping.scroll_docs(-1),
  })
  -- 遅延ロードされる独自定義コマンド用のsource
  local my_source = {}
  function my_source:complete(_, callback)
    callback({
      { label = 'Term' },
      { label = 'TermV' },
      { label = 'TermHere' },
      { label = 'TermHereV' },
      { label = 'Terminal' },
    })
  end
  cmp.register_source('my_source', my_source)
  cmp.setup({
    -- skkeleton {{{
    mapping = cmp.mapping.preset.insert({
      ['<Tab>'] = cmp.mapping({
        i = function(fallback)
          if cmp.visible() then
            return cmp.select_next_item()
          end
          fallback()
        end,
      }),
      ['<S-Tab>'] = cmp.mapping({
        i = function(fallback)
          if cmp.visible() then
            return cmp.select_prev_item()
          end
          fallback()
        end,
      }),
    }),
    sources = cmp.config.sources({
      { name = 'skkeleton' },
    }),
    -- }}}
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
  })
  -- 検索
  cmp.setup.cmdline({'/', '?'}, {
    mapping = cmdline_mapping,
    sources = {
      { name = 'buffer' }
    }
  })
  -- コマンド
  cmp.setup.cmdline({':'}, {
    mapping = cmdline_mapping,
    sources = {
      { name = 'path' },
      { name = 'my_source' },
      { name = 'cmdline' },
    }
    -- NOTE: 以下の書き方だと、source同士が結合されて新しいsourceが作られるらしい。
    --       以下の書き方だとmy_sourceの一部が上手く補完されなかった。
    -- sources = cmp.config.sources({
    --   { name = 'path' },
    -- }, {
    --   { name = 'cmdline' }
    -- }, {
    --   { name = 'my_source' }
    -- })
  })
end

return M
