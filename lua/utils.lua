-------------------------------------------------------------------------------
-- 共通処理
-- luaで書いた共通処理はここに集める
-------------------------------------------------------------------------------
local fn  = vim.fn
local g   = vim.g

local M   = {}

--
-- booleanな値を返すvim.fnのwrapper function
-- 例）if require("utils").bool_fn.has('mac') then ... end
--
M.bool_fn = setmetatable({}, {
  __index = function(_, key)
    return function(...)
      local v = vim.fn[key](...)
      if not v or v == 0 or v == "" then
        return false
      elseif type(v) == "table" and next(v) == nil then
        return false
      end
      return true
    end
  end,
})

--
-- テーブル内に値が存在するか
-- →phpのin_array()的な使い方を想定
--
function M.in_array(value, array)
  for _, v in ipairs(array) do
    if v == value then
      return true
    end
  end
  return false
end

--
-- WSLか
--
function M.is_wsl()
  return M.bool_fn.has("linux") and M.bool_fn.exists("$WSLENV")
end

--
-- utils#echo_error_message()のラッパー
--
function M.echo_error_message(exception, error_code, param)
  -- NOTE: luaはデフォルト引数が使えない...
  if param then
    -- パラメータあり
    fn["utils#echo_error_message"](exception, error_code, param)
  else
    -- パラメータなし
    fn["utils#echo_error_message"](exception, error_code)
  end
end

---
-- 透過色を16進数で返す
-- @param string bg_color 背景色のカラーコード(16進数)。例: "#FFFFFF"
-- @param string target_color 対象色のカラーコード(16進数)。例: "#000000"
-- @param number alpha 透過率。0から1の値で指定する。0に近いほど背景色が優先され、1に近いほど対象色が優先される。
-- @return string 透過させた色のカラーコード(16進数)。例: "#808080"
function M.transparent_color(bg_color, target_color, alpha)
  -- target_colorにcolornameが指定されている場合、colorcodeに変換
  if string.sub(target_color, 1, 1) ~= "#" then
    target_color = M.get_colorcode_by_colorname(target_color)
  end

  if string.sub(target_color, 1, 1) ~= "#" and (not target_color or target_color == "") then
    return ''
  end

  local result_color = "#"

  -- 背景色と対象色を10進数に変換して、透過させた色を計算
  for i = 1, 3 do                                                   -- R, G, Bごとに処理
    local bg_hex = string.sub(bg_color, i * 2, (i * 2) + 1)         -- 背景(16進数)
    local bg_dec = tonumber(bg_hex, 16)                             -- 背景(10進数)
    local target_hex = string.sub(target_color, i * 2, (i * 2) + 1) -- 対象(16進数)
    local target_dec = tonumber(target_hex, 16)                     -- 対象(10進数)

    -- 透過した結果(10進数)
    local result_dec = math.floor(alpha * bg_dec + (1 - alpha) * target_dec)
    -- カラーコード
    result_color = result_color .. string.format("%02X", result_dec)
  end

  return result_color
end

---
-- 色名をカラーコードに変換
-- @param string colorname
-- @return string colorcode
-- NOTE: builtinにあるような気もするけど見つけられなかったので一旦これを使う
function M.get_colorcode_by_colorname(colorname)
  local colornames = {
    ["Black"]        = "#000000",
    ["DarkBlue"]     = "#00008B",
    ["DarkGreen"]    = "#006400",
    ["DarkCyan"]     = "#008B8B",
    ["DarkRed"]      = "#8B0000",
    ["DarkMagenta"]  = "#8B008B",
    ["Brown"]        = "#A52A2A",
    ["DarkYellow"]   = "#A9A900",
    ["LightGray"]    = "#D3D3D3",
    ["LightGrey"]    = "#D3D3D3",
    ["Gray"]         = "#808080",
    ["Grey"]         = "#808080",
    ["DarkGray"]     = "#A9A9A9",
    ["DarkGrey"]     = "#A9A9A9",
    ["Blue"]         = "#0000FF",
    ["LightBlue"]    = "#ADD8E6",
    ["Green"]        = "#00FF00",
    ["LightGreen"]   = "#90EE90",
    ["Cyan"]         = "#00FFFF",
    ["LightCyan"]    = "#E0FFFF",
    ["Red"]          = "#FF0000",
    ["LightRed"]     = "#FFA07A",
    ["Magenta"]      = "#FF00FF",
    ["LightMagenta"] = "#FF00FF",
    ["Yellow"]       = "#FFFF00",
    ["LightYellow"]  = "#FFFFE0",
    ["White"]        = "#FFFFFF"
  }

  return colornames[colorname]
end

--
-- highlight colorを取得する
-- NOTE: linkには対応していない...
--
function M.get_highlight_color(highlight_group, highlight_arg)
  local cmd_output = vim.fn.execute('hi ' .. highlight_group)
  local is_reverse = string.match(cmd_output, "reverse")
  local color

  if is_reverse and (highlight_arg == 'guifg' or highlight_arg == 'guibg') then
    -- `reverse` が適用されている場合、前景色と背景色を入れ替えて取得
    local fg_color = string.match(cmd_output, "guifg=(#%x+)")
    local bg_color = string.match(cmd_output, "guibg=(#%x+)")

    if highlight_arg == 'guifg' then
      color = bg_color -- 背景色を返す
    elseif highlight_arg == 'guibg' then
      color = fg_color -- 前景色を返す
    end
  else
    -- `reverse` が適用されていない場合、通常の方法で色を取得
    color = string.match(cmd_output, highlight_arg .. "=(#%x+)")
  end

  if color ~= "" then
    return color
  else
    return nil
  end
end

--
-- カラースキームをランダムに変更する
--
function M.change_colorscheme()
  -- 対象のカラースキーム
  local target_colorschemes = {}
  if vim.g.colors_name == nil or vim.g.colors_name == "" then
    -- カラースキームが設定されて無ければ定数の中身をそのまま使う
    target_colorschemes = vim.g["my#const"]["favorite_colorschemes"]
  else
    -- 現在のカラースキームを除いたリストを作成
    for _, scheme in ipairs(vim.g["my#const"]["favorite_colorschemes"]) do
      if scheme ~= vim.g.colors_name then
        table.insert(target_colorschemes, scheme)
      end
    end
  end

  -- 乱数
  math.randomseed(os.time())
  local random_num = math.random(1, #target_colorschemes)

  -- カラースキームを変更
  vim.cmd("colorscheme " .. target_colorschemes[random_num])
end

--
-- インデントをセットする(バッファローカル)
--
function M.setlocal_indent(indent)
  vim.bo.tabstop     = indent
  vim.bo.shiftwidth  = indent
  vim.bo.softtabstop = indent
end

--
-- git projectかどうか
--
function M.is_git_project()
  return tonumber(vim.fn.system('git status > /dev/null 2>&1; echo $?')) == 0
end

--
-- branch名を取得
--
function M.get_branch_name()
  local branch_or_commit = vim.fn.system('git rev-parse --abbrev-ref HEAD'):gsub("\n", "")
  if branch_or_commit == 'HEAD' then
    -- Detached HEAD 状態（特定のコミットにチェックアウトされている）
    branch_or_commit = vim.fn.system('git rev-parse HEAD'):gsub("\n", "")
  end
  return branch_or_commit
end

--
-- 未pull、未pushなcommit数と、リモートブランチ情報を取得する
-- TODO: scripts/commit_status.shの処理内容をここに実装する
--
function M.get_git_infomations()
  -- FIXME: 一旦
  return fn['utils#delete_line_breaks'](fn.system('~/.config/nvim/scripts/commit_status.sh'))
end

--
-- git上の変更があるか
--
function M.has_git_changed()
  fn.system("git status | grep 'nothing to commit, working tree clean'")
  return vim.v.shell_error ~= 0
end

--
-- リモートブランチ情報のテキストを返す
--
function M.remote_branch_info_text()
  if not g['my#git_infomations']['exists_remote_branch'] then
    return ""
  else
    -- リモートブランチがあれば空文字を返す
    return ""
  end
end

return M
