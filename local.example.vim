" ==============================================================================
" local.vimのexample
"
" 環境ごとの設定を書く
" colorschemeをこっちで設定するようにしているのは、
" 気分、環境によってころころ変えたいけど、いちいちgitの差分出るのが嫌だから
" ==============================================================================
" cocで使用するnodeのパス指定
" let g:coc_node_path = "/opt/homebrew/opt/node@18/bin/node"

" NOTE: 定数の中身を変更したい場合は以下のような感じで
" unlo g:my#const
" let g:my#const['term_bgcolor'] = g:my#const['bg_colors']['synthwave_alpha']
" lockv g:my#const

" カラースキームをランダムに設定
lua require("utils").change_colorscheme()
