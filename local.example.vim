" ==============================================================================
" local.vimのexample
"
" 環境ごとの設定を書く
" colorschemeをこっちで設定するようにしているのは、
" 気分、環境によってころころ変えたいけど、いちいちgitの差分出るのが嫌だから
" NOTE: プラグインを前提とした処理をここに書くと、プラグインが入ってない場合にエラーになるので注意
" ==============================================================================
" cocで使用するnodeのパス指定
" let g:coc_node_path = "/opt/homebrew/opt/node@18/bin/node"

" NOTE: 定数の中身を変更したい場合は以下のような感じで
" unlo g:my#const
" let g:my#const['term_bgcolor'] = g:my#const['bg_colors']['synthwave_alpha']
" lockv g:my#const

" denopsのデバッグをオンにする
" let g:denops#debug = 1

lua << EOF
  vim.api.nvim_create_augroup("MyLocalAutocmds", {})
  -- indentを4にする
  vim.api.nvim_create_autocmd("FileType", {
    group = "MyLocalAutocmds",
    pattern = { "php", "java" },
    callback = function()
      require("utils.utils").setlocal_indent(4)
    end
  })

  require("utils.utils").change_colorscheme()
EOF

" カラースキームをランダムに設定
lua require("utils.utils").change_colorscheme()

