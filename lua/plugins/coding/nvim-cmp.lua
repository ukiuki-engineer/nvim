local M = {}

function M.lua_source()
  local const           = vim.g["my#const"]
  local cmp             = require('cmp')

  -- cmdlineのマッピング(検索/コマンド共通)
  local cmdline_mapping = cmp.mapping.preset.cmdline({
    -- 履歴の選択はデフォルト操作で
    ["<C-n>"] = cmp.mapping.scroll_docs(1),
    ["<C-p>"] = cmp.mapping.scroll_docs(-1),
  })

  -- 遅延ロードされる独自定義コマンド用のsource
  local my_source       = {}
  function my_source:complete(_, callback)
    -- コマンドリストを初期化
    local my_commands = {}

    -- paste_image.luaがロードされてなければコマンドリストに追加
    if vim.g['vimrc#loaded_paste_image'] == nil then
      table.insert(my_commands, { label = 'PasteImage' })
    end

    -- terminal.luaがロードされてなければコマンドリストに追加
    if vim.g['vimrc#loaded_terminal'] == nil then
      table.insert(my_commands, { label = 'Term' })
      table.insert(my_commands, { label = 'TermV' })
      table.insert(my_commands, { label = 'TermHere' })
      table.insert(my_commands, { label = 'TermHereV' })
      table.insert(my_commands, { label = 'Terminal' })
    end

    callback(my_commands)
  end

  -- sourceを登録
  cmp.register_source('my_source', my_source)

  -- 読み込むsourceを定義
  local sources =
  {
    { name = 'skkeleton' },
  }
  -- lspconfigを使用するなら以下を追加
  if vim.g.lsp_plugin_selection == const.lsp_plugin_selection_mason_lspconfig then
    table.insert(sources, { name = 'nvim_lsp' })
    table.insert(sources, { name = 'vsnip' })
  end

  cmp.setup({
    snippet = vim.g.lsp_plugin_selection == const.lsp_plugin_selection_mason_lspconfig
        and {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
          end,
        }
        or {},
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
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources(sources),
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
  })
  -- 検索
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmdline_mapping,
    sources = {
      { name = 'buffer' }
    }
  })
  -- コマンド
  cmp.setup.cmdline({ ':' }, {
    mapping = cmdline_mapping,
    sources = { -- NOTE: cmp.config.sources({...})とすると、
      -- source同士が結合されて新しいsourceが作られるので上手くいかない
      { name = 'path' },
      { name = 'my_source' },
      { name = 'cmdline' },
    }
  })
end

return M
