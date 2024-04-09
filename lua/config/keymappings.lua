--=============================================================================
-- keymappings
-- plugin用以外のkeymapを定義する
-- plugin用のmappingは各pluginの設定中で行なう
--
-- NOTE: <leader>, <space>の使い分けの方針は一応以下だけど、結構曖昧だしほとんど雰囲気
--         g: コマンドを実行する系？なんか違うような気もする
--   <leaer>: 何かしらのactionを起こす系
--   <space>: 何かを表示する系
--=============================================================================
-------------------------------------------------------------------------------
-- localな変数、function
-------------------------------------------------------------------------------
local opts = { noremap = true, silent = true }

-- 次のタブに移動(タブが一個ならtabnewする)
local function tabnextOrNew()
  local tab_count = #vim.fn.gettabinfo()
  if tonumber(tab_count) > 1 then
    vim.cmd([[tabnext]])
  else
    vim.cmd([[tabnew]])
  end
end

-- 前のタブに移動(タブが一個ならtabnewする)
local function tabpOrNew()
  local tab_count = #vim.fn.gettabinfo()
  if tonumber(tab_count) > 1 then
    vim.cmd([[tabp]])
  else
    vim.cmd([[tabnew | -tabmove]])
  end
end
-------------------------------------------------------------------------------
-- NOTE: markは使ってないのでleaderにする
vim.g.mapleader = "m"
-------------------------------------------------------------------------------
-- 通常のmapping
-------------------------------------------------------------------------------
-- <C-d>でdelete
vim.keymap.set("i", "<C-d>", "<Del>", opts)

-- esc2回で検索結果ハイライトをオフに
vim.keymap.set("n", "<Esc><Esc>", ":nohlsearch<CR>", opts)

-- バッファ移動
vim.keymap.set("n", "gb", ":bn<CR>", opts)
vim.keymap.set("n", "gB", ":bN<CR>", opts)

-- 引用
-- NOTE: 本当はmarkdownのftpluginに入れようとしたけど、グローバルな設定でも良さそうなのでここに入れとく
vim.keymap.set({ "n", "x" }, "g>", ":norm! I><space><CR>", opts)

-- タブ移動
vim.keymap.set("n", "<TAB>", tabnextOrNew, opts)
vim.keymap.set("n", "gt", tabnextOrNew, opts)
vim.keymap.set("n", "<S-TAB>", tabpOrNew, opts)
vim.keymap.set("n", "gT", tabpOrNew, opts)

-- NOTE: <TAB>のmappingが<C-i>にも適用されてしまうので元の動きに戻す
vim.keymap.set({ "n" }, "<C-i>", "<TAB>", opts)

-- タブを閉じる
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", opts)
-------------------------------------------------------------------------------
-- 遅延で定義するmapping(vim起動時にあれこれ処理させたくない)
-------------------------------------------------------------------------------
vim.api.nvim_create_augroup("lazy_keymapping", {})

-- <space>1 ~ 9でタブ1 ~ 9に移動
vim.api.nvim_create_autocmd({ "TabNew" }, {
  group = "lazy_keymapping",
  callback = function()
    for i = 1, 9 do
      vim.keymap.set("n", "<space>" .. i, ":" .. i .. "tabnext<CR>", opts)
    end
  end,
  once = true,
})

-- 全角文字に行内ジャンプ
vim.api.nvim_create_autocmd({ "BufRead", "CursorMoved" }, {
  group = "lazy_keymapping",
  callback = function()
    -- 全角文字と半角文字の対応を定義
    require("utils").jump_to_zenkaku({
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
  end,
  once = true,
})

-- cmdlineモードのkeymapping
vim.api.nvim_create_autocmd({ "CmdLineEnter" }, {
  group = "lazy_keymapping",
  callback = function()
    -- cmdlineモードをemacsキーバインドでカーソル移動
    vim.keymap.set("c", "<C-b>", "<Left>", { noremap = true })
    vim.keymap.set("c", "<C-f>", "<Right>", { noremap = true })
    vim.keymap.set("c", "<C-a>", "<Home>", { noremap = true })
    vim.keymap.set("c", "<C-e>", "<End>", { noremap = true })
    vim.keymap.set("c", "<C-d>", "<Del>", { noremap = true })
  end,
  once = true,
})
