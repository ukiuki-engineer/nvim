--=============================================================================
-- keymappings
-- plugin用以外のkeymapを定義する
-- plugin用のmappingは各pluginの設定中で行なう
--
-- NOTE: <leader>, <space>の使い分けの方針
-- <leaer>: 何かしらのactionを起こす系
-- <space>: 何かを表示する系
--=============================================================================
-------------------------------------------------------------------------------
-- 二重読み込み防止
-------------------------------------------------------------------------------
if vim.g['vimrc#loaded_keymappings'] then
  return
end
vim.g['vimrc#loaded_keymappings'] = true
-------------------------------------------------------------------------------
-- localな変数、function
-------------------------------------------------------------------------------
local keyset                      = vim.keymap.set
local opts                        = { noremap = true, silent = true }
local augroup                     = vim.api.nvim_create_augroup
local au                          = vim.api.nvim_create_autocmd

-- 次のタブに移動(タブが一個ならtabnewする)
local function tabnext()
  local tab_count = #vim.fn.gettabinfo()
  if tonumber(tab_count) > 1 then
    vim.cmd([[tabnext]])
  else
    vim.cmd([[tabnew]])
  end
end

-- 前のタブに移動(タブが一個ならtabnewする)
local function tabp()
  local tab_count = #vim.fn.gettabinfo()
  if tonumber(tab_count) > 1 then
    vim.cmd([[tabp]])
  else
    vim.cmd([[tabnew | -tabmove]])
  end
end

-- 全角文字に行内ジャンプ
local function jump_to_zenkaku(hankaku_zenkaku_pairs)
  for hankaku, zenkaku in pairs(hankaku_zenkaku_pairs) do
    keyset({ 'n', 'x' }, '<leader>f' .. hankaku, 'f' .. zenkaku, opts)
    keyset({ 'n', 'x' }, '<leader>t' .. hankaku, 't' .. zenkaku, opts)
    keyset({ 'n', 'x' }, '<leader>F' .. hankaku, 'F' .. zenkaku, opts)
    keyset({ 'n', 'x' }, '<leader>T' .. hankaku, 'T' .. zenkaku, opts)
    keyset('n', '<leader>df' .. hankaku, 'df' .. zenkaku, opts)
    keyset('n', '<leader>dt' .. hankaku, 'dt' .. zenkaku, opts)
    keyset('n', '<leader>cf' .. hankaku, 'cf' .. zenkaku, opts)
    keyset('n', '<leader>ct' .. hankaku, 'ct' .. zenkaku, opts)
    keyset('n', '<leader>yf' .. hankaku, 'yf' .. zenkaku, opts)
    keyset('n', '<leader>yt' .. hankaku, 'yt' .. zenkaku, opts)
  end
end
-------------------------------------------------------------------------------
-- NOTE: markは使ってないのでleaderにする
vim.g.mapleader = "m"
-------------------------------------------------------------------------------
-- 通常のmapping
-------------------------------------------------------------------------------
keyset("i", "jj", "<Esc>", opts)
keyset("n", "<Esc><Esc>", ":nohlsearch<CR>", opts)
keyset("n", "gb", ":bn<CR>", opts)
keyset("n", "gB", ":bN<CR>", opts)
keyset({ "n", "x" }, "<C-j>", "7j", opts)
keyset({ "n", "x" }, "<C-k>", "7k", opts)

-- タブ移動
keyset("n", "<TAB>", tabnext, opts)
keyset("n", "gt", tabnext, opts)
keyset("n", "<S-TAB>", tabp, opts)
keyset("n", "gT", tabp, opts)

-- NOTE: <TAB>のmappingが<C-i>にも適用されてしまうので元の動きに戻す
keyset({ "n" }, "<C-i>", "<TAB>", opts)

-- タブを閉じる
keyset("n", "<leader>tc", ":tabclose<CR>", opts)

-- cmdlineモードをemacsキーバインドでカーソル移動
-- keyset("c", "<C-b>", "<Left>", opts)
-- keyset("c", "<C-f>", "<Right>", opts)
-- keyset("c", "<C-a>", "<Home>", opts)
-- keyset("c", "<C-e>", "<End>", opts)
-- keyset("c", "<C-d>", "<Del>", opts)
-- FIXME: 上の書き方だと何故か効かないので一旦vimscriptの書き方で
vim.cmd([[
  cnoremap <C-b> <Left>
  cnoremap <C-f> <Right>
  cnoremap <C-a> <Home>
  cnoremap <C-e> <End>
  cnoremap <C-d> <Del>
]])
-------------------------------------------------------------------------------
-- 遅延で定義するmapping(vim起動時にあれこれ処理させたくない)
-------------------------------------------------------------------------------
augroup("map_zenkaku", {})
au({ "BufRead", "InsertEnter" }, {
  group = "map_zenkaku",
  callback = function()
    -- 全角文字と半角文字の対応を定義
    jump_to_zenkaku({
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
  end,
  once = true,
})
