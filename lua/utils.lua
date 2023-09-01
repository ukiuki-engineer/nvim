-------------------------------------------------------------------------------
-- 共通処理
-- luaで書いた共通処理はここに集める
-------------------------------------------------------------------------------
local fn = vim.fn
local g  = vim.g

local M  = {}

---
-- 透過色を計算する関数
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
-- NOTE: vim内の関数であるような気もするけど見つけられなかったので一旦これを使う
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
  return string.gsub(vim.fn.system('git rev-parse --abbrev-ref HEAD'), "\n", "")
end

--
-- 未pull、未pushなcommit数と、リモートブランチ情報を取得する
-- TODO: scripts/commit_status.shの処理内容をここに実装する
--
function M.get_git_infomations()
  -- TODO: 一旦
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
  if g.git_commit_status == nil then
    return
  end

  if not g['my#git_infomations']['exists_remote_branch'] then
    return ""
  else
    -- リモートブランチがあれば空文字を返す
    return ""
  end
end

return M
