" ================================================================================
" LSP and Completion
" ================================================================================
"
" coc.nvim
"
" FIXME: bladeでも、phpの関数のhoverが読みたい
" NOTE: coc-bladeは、"b:xxx"と打つと補完候補が出る
" NOTE: :CocCommand xx.xxで各拡張機能のコマンドを色々呼び出せる
" NOTE: スペルチェッカーの辞書登録
" .config/nvim/coc-settings.jsonの"cSpell.userWords"に追加
"   :CocCommand cSpell.addWordToUserDictionary
" ./.vim/coc-settings.jsonの"cSpell.ignoreWords"に追加
"   :CocCommand cSpell.addIgnoreWordToWorkspace
" NOTE: Laravel固有のメソッドに対して補完やホバーを行うには、補完ヘルパーファイルを出力する必要がある
" 手順は以下の通り
" composer require --dev barryvdh/laravel-ide-helper # ライブラリをインストール
" composer require barryvdh/laravel-ide-helper:*     # ↑で上手くいかなかった場合
" php artisan ide-helper:generate                    # _ide_helper.phpを生成
" php artisan ide-helper:models --nowrite            # _ide_helper_models.phpを生成
function! plugins#lsp_and_completion#hook_add_coc() abort
  " coc-extensions
  let g:coc_global_extensions = [
    \ '@yaegassy/coc-intelephense',
    \ 'coc-blade',
    \ 'coc-css',
    \ 'coc-cssmodules',
    \ 'coc-docker',
    \ 'coc-eslint',
    \ 'coc-fzf-preview',
    \ 'coc-html',
    \ 'coc-jedi',
    \ 'coc-json',
    \ 'coc-lua',
    \ 'coc-php-cs-fixer',
    \ 'coc-prettier',
    \ 'coc-sh',
    \ 'coc-snippets',
    \ 'coc-solargraph',
    \ 'coc-spell-checker',
    \ 'coc-sql',
    \ 'coc-tsserver',
    \ 'coc-vetur',
    \ 'coc-vimlsp',
    \ 'coc-word',
    \ 'coc-xml',
    \ 'coc-yaml',
    \ 'coc-yank',
  \ ]

  " CocCommand fzf-preview.CocOutline
  nnoremap <silent> mo :CocCommand fzf-preview.CocOutline<CR>
  " ファイル名検索
  nnoremap <silent> <space>f :CocCommand fzf-preview.ProjectFiles<CR>
  " バッファの中からファイル名検索
  nnoremap <silent> <space>b :CocCommand fzf-preview.Buffers<CR>
  " grep
  nnoremap <space>g :CocCommand fzf-preview.ProjectGrep<Space>
  " 開いているバッファをgrep
  command! BufferLines :CocCommand fzf-preview.BufferLines
  " カレントバッファの変更箇所(:changesのfzf版)
  command! Changes :CocCommand fzf-preview.Changes
  " ディレクトリ内をファイル名検索
  command! Files :CocCommand fzf-preview.DirectoryFiles
  " git status
  command! GitStatus :CocCommand fzf-preview.GitStatus
  " カレントバッファをgrep
  command! Lines :CocCommand fzf-preview.Lines
endfunction

function! plugins#lsp_and_completion#hook_source_coc() abort
  " 補完候補の決定
  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
  " 補完候補の選択
  inoremap <silent><expr> <TAB>  coc#pum#visible() ? coc#pum#next(1) : "\<TAB>"
  inoremap <silent><expr> <S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<S-TAB>"
  inoremap <silent><expr> <C-n> coc#pum#visible() ? coc#pum#next(1) : coc#refresh()
  inoremap <silent><expr> <C-p> coc#pum#visible() ? coc#pum#prev(1) : coc#refresh()
  " 定義ジャンプ
  nnoremap <silent> <space>d <Plug>(coc-definition)
  " ドキュメント表示
  nnoremap <silent> <space>h :call plugins#lsp_and_completion#show_documentation()<CR>
  " float windowへジャンプ
  nnoremap <silent> <space>j <Plug>(coc-float-jump)
  " 参照箇所表示
  nnoremap <silent> <space>r <Plug>(coc-references)
  " カーソル位置のsymbolをハイライト(*でカーソル位置を検索するノリ。shiftがspaceに変わっただけ。)
  nnoremap <silent> <space>8 :call CocActionAsync('highlight')<CR>
  " 上記をダブルクリックでもできるように
  nnoremap <silent> <2-LeftMouse> :call CocActionAsync('highlight')<CR>
  " nnoremap <LeftMouse> <LeftMouse>:call CocActionAsync('highlight')<CR>
  " 指摘箇所へジャンプ
  nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
  nnoremap <silent> ]g <Plug>(coc-diagnostic-next)
  " coc-outlineを表示
  nnoremap <silent><nowait> <space>o :call plugins#lsp_and_completion#toggle_outline()<CR>
  " coc-outlineにジャンプ
  " NOTE: ジャンプ前の箇所に戻るには、普通に<C-o>で
  " NOTE: outline tree上で<space>tで、treeの開閉ができる
  nnoremap <silent><nowait> <space>t :call CocActionAsync('showOutline')<CR>
  " ウィンドウのスクロール
  nnoremap <nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1, 1) : "7j"
  nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0, 1) : "7k"
  nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <nowait><expr> <C-i> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1, 1)\<CR>" : "\<Right>"
  inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<CR>" : "\<Right>"
  inoremap <nowait><expr> <C-k> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0, 1)\<CR>" : "\<Left>"
  inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<CR>" : "\<Left>"
  " フォーマッターを呼び出す
  command! Format :call CocAction('format')
endfunction

" ドキュメント表示
function! plugins#lsp_and_completion#show_documentation() abort
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" coc-outlineを表示
function! plugins#lsp_and_completion#toggle_outline() abort
  let winid = coc#window#find('cocViewId', 'OUTLINE')
  if winid == -1
    call CocActionAsync('showOutline', 1)
  else
    call coc#window#close(winid)
  endif
endfunction

