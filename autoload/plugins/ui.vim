" ================================================================================
" UI
" ================================================================================
"
" nvim-tree
"
" NOTE: tree上で`g?`とするとヘルプが開く
" 小指が痛いのでマウスで操作しやすいようにカスタマイズしたい...
" TODO: 画面分割しててもマウスクリックで開けるように
"       (マウスクリック時の挙動がOと同じになるように)
" TODO: マウスでツリーの開閉はできないのか？
"       クリックしたらnvim-tree-api.tree.open()を呼ぶボタンをlualineに配置すれば良いかな？
" TODO: Visual選択範囲を一括削除できるように
function! plugins#ui#hook_add_nvim_tree() abort
  nnoremap <silent> <C-n> :NvimTreeToggle<CR>
  nnoremap <silent> <C-w>t :NvimTreeFindFile<CR>
endfunction
