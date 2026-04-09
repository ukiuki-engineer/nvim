" ================================================================================
" init.vim(VSCode NeoVim用)
" ================================================================================
" ------------------------------------------------------------------------------
" options
" ------------------------------------------------------------------------------
" runtimepathを追加(まだ使ってないけど...)
set runtimepath+=~/dotfiles/vscode-neovim
" オートインデント
set autoindent
" クリップボード連携
set clipboard+=unnamed
" カーソル行、列を表示
set cursorline cursorcolumn
" 検索時の挙動
set ignorecase smartcase incsearch hlsearch nowrapscan
" ------------------------------------------------------------------------------
" highlights
" ------------------------------------------------------------------------------
hi CursorColumn guibg=#414041
" ------------------------------------------------------------------------------
" autocmd
" ------------------------------------------------------------------------------
augroup MyVSCodeInitVim
  autocmd!
  " 日本語入力切り替え {{{
  if has('mac') && exepath('im-select') != ""
    " MacOS用
    " NOTE: im-selectをインストールしてPATHを通しておく
    autocmd InsertLeave,InsertEnter * :call jobstart('im-select com.apple.keylayout.ABC')
  endif
  if has('win32') && exepath('zenhan.exe') != ""
    " Windows用
    " NOTE: zenhanをインストールしてPATHを通しておく
    autocmd InsertLeave,InsertEnter * :call jobstart('zenhan.exe 0')
  endif
  " }}}
augroup END
" ------------------------------------------------------------------------------
" keymaps
" ------------------------------------------------------------------------------
" markはあまり使わないので潰してleaderにする
let g:mapleader = "m"

nnoremap <C-j> 7j
nnoremap <C-k> 7k
vnoremap <C-j> 7j
vnoremap <C-k> 7k

" Escを2回押すと検索結果ハイライトを非表示にする
nnoremap <silent> <Esc><Esc> :nohlsearch<CR><Esc>

" VSCode側の機能を呼び出すmapping {{{
" NOTE:
" https://code.visualstudio.com/docs/getstarted/keybindings

" gitの差分へジャンプ
nnoremap ]c :call VSCodeNotify('workbench.action.editor.nextChange')<CR>
nnoremap [c :call VSCodeNotify('workbench.action.editor.previousChange')<CR>
" 選択範囲をstage
nnoremap <leader>hs :call VSCodeNotify('git.stageSelectedRanges')<CR>
" 選択範囲をunstage
nnoremap <leader>hu :call VSCodeNotify('git.unstageSelectedRanges')<CR>
" 選択範囲を元に戻す
nnoremap <leader>hr :call VSCodeNotify('git.revertSelectedRanges')<CR>
" 定義ジャンプ
nnoremap gd :call VSCodeNotify('editor.action.revealDefinition')<CR>
" hover表示
nnoremap K :call VSCodeNotify('editor.action.showHover')<CR>
" }}}

" 日本語へのジャンプ、加工がしやすくなるように {{{
lua << END
  local function map_zenkaku(hankaku_zenkaku_pairs)
    for hankaku, zenkaku in pairs(hankaku_zenkaku_pairs) do
      vim.keymap.set({ 'n', 'x' }, '<leader>f' .. hankaku, 'f' .. zenkaku, {})
      vim.keymap.set({ 'n', 'x' }, '<leader>t' .. hankaku, 't' .. zenkaku, {})
      vim.keymap.set({ 'n', 'x' }, '<leader>F' .. hankaku, 'F' .. zenkaku, {})
      vim.keymap.set({ 'n', 'x' }, '<leader>T' .. hankaku, 'T' .. zenkaku, {})
      vim.keymap.set('n', '<leader>df' .. hankaku, 'df' .. zenkaku, {})
      vim.keymap.set('n', '<leader>dt' .. hankaku, 'dt' .. zenkaku, {})
      vim.keymap.set('n', '<leader>cf' .. hankaku, 'cf' .. zenkaku, {})
      vim.keymap.set('n', '<leader>ct' .. hankaku, 'ct' .. zenkaku, {})
      vim.keymap.set('n', '<leader>yf' .. hankaku, 'yf' .. zenkaku, {})
      vim.keymap.set('n', '<leader>yt' .. hankaku, 'yt' .. zenkaku, {})
    end
  end
  map_zenkaku({
    [" "] = "　",
    ["!"] = "！",
    ["%"] = "％",
    ["&"] = "＆",
    ["("] = "（",
    [")"] = "）",
    ["+"] = "＋",
    [","] = "、",
    ["-"] = "ー",
    ["."] = "。",
    ["/"] = "・",
    ["0"] = "０",
    ["1"] = "１",
    ["2"] = "２",
    ["3"] = "３",
    ["4"] = "４",
    ["5"] = "５",
    ["6"] = "６",
    ["7"] = "７",
    ["8"] = "８",
    ["9"] = "９",
    [":"] = "：",
    [";"] = "；",
    ["<"] = "＜",
    ["="] = "＝",
    [">"] = "＞",
    ["?"] = "？",
    ["["] = "「",
    ["]"] = "」",
    ["a"] = "あ",
    ["e"] = "え",
    ["i"] = "い",
    ["o"] = "お",
    ["u"] = "う",
    ["{"] = "『",
    ["|"] = "｜",
    ["}"] = "』",
  })
END
" }}}

