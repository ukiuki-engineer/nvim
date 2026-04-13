-- ==========================================================================
-- プラグイン一覧
-- ==========================================================================
return function(deps)
  deps.add({ source = "https://github.com/machakann/vim-highlightedyank" })
  deps.add({ source = "https://github.com/haya14busa/vim-edgemotion" })
  deps.add({ source = "https://github.com/nvim-tree/nvim-web-devicons" })
  -- TODO: oilはなんか上手く動いたり動かなかったり
  deps.add({ source = "https://github.com/stevearc/oil.nvim" })
  -- TODO: endwinresizer
  -- TODO: vim-surround
  -- TODO: vim-maketable
end
