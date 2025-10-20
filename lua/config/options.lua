-- 文字コード
-- NOTE: `:h encoding-values`
-- Vim が内部処理に利用する文字コード。開いたファイルが文字化けしてたときにいじるのはこれ。
vim.opt.encoding = 'utf-8'
-- Vim が 既存ファイルの 文字コード推定に使う文字コードのリスト。
vim.opt.fileencodings = 'utf-8,sjis,iso-2022-jp,euc-jp'
--  新規ファイルを作成する際の文字コード
vim.opt.fileencoding = 'utf-8'

-- スワップファイルを作らない
vim.opt.swapfile = false
-- マウス有効化
vim.opt.mouse = 'a'
-- 編集中のファイルが変更されたら自動で読み直す
vim.opt.autoread = true
-- カーソル行を表示
vim.opt.cursorline = true
-- カーソル列を表示
vim.opt.cursorcolumn = true
-- ルーラーを表示しない
vim.opt.ruler = false
-- 行番号を表示
vim.opt.number = true
-- タブや改行を表示
vim.opt.list = true
-- タブや改行の表示記号を定義
-- vim.opt.listchars=tab:»-,trail:-,eol:↓,extends:»,precedes:«,nbsp:%

-- 画面を垂直分割する際に右に開く
vim.opt.splitright = true
-- 画面を水平分割する際に下に開く
vim.opt.splitbelow = true

-- 差分
-- 縦分割
vim.opt.diffopt:append("vertical")
-- 空白を無視
-- vim.opt.diffopt:append("iwhiteall")

-- 検索時の挙動
vim.opt.wrapscan = false
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 置換時に画面分割して該当個所を表示
vim.opt.inccommand = 'split'

-- sessionに保存する内容を指定
vim.opt.sessionoptions = 'buffers,curdir,tabpages'
-- Tab文字を半角スペースにしない
vim.opt.expandtab = false

-- viewにoptions, curdirを保存しない
vim.opt.viewoptions:remove("options")
vim.opt.viewoptions:remove("curdir")

-- インデントは基本的に2
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

-- 符号なし数字として扱う
vim.opt.nrformats:append("unsigned")

-- window分割しててもstatuslineを1つに
vim.opt.laststatus = 3

-- タブとか改行の表示
vim.opt.list = true
vim.opt.listchars:append({
  space    = "⋅",
  tab      = "»-",
  trail    = "-",
  eol      = "↓",
  extends  = "»",
  precedes = "«",
  nbsp     = "%"
})
