local M = {}

function M.lua_source()
  local const           = vim.g["my#const"]
  local cmp             = require('cmp')
  local use_lspconfig   = vim.g.lsp_plugin_selection == const.lsp_plugin_selection_mason_lspconfig

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
  if use_lspconfig then
    table.insert(sources, { name = 'nvim_lsp' })
    table.insert(sources, { name = 'luasnip' })
  end

  local insert_mode_mapping
  if use_lspconfig then
    insert_mode_mapping = cmp.mapping.preset.insert({
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
    })
  else
    -- coc運用時はTabをcoc側に任せつつ、cmp(skkeleton source)の操作キーは残す
    insert_mode_mapping = cmp.mapping.preset.insert({
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-y>'] = cmp.mapping.confirm({ select = true }),
      ['<C-e>'] = cmp.mapping.abort(),
    })
  end

  cmp.setup({
    snippet = use_lspconfig
        and {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        }
        or {},
    mapping = insert_mode_mapping,
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
