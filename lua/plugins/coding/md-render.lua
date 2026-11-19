local M = {}

function M.lua_source()
  local preview = require('md-render.preview')
  local build_content = preview.build_content

  -- 初期展開の設定項目がないため、描画APIで表の展開状態を補う。
  preview.build_content = function(lines, opts)
    opts = opts or {}
    opts.expand_state = opts.expand_state or {}
    local content = build_content(lines, opts)

    -- 表のblock_idは、frontmatterを除いた本文内の行番号。
    local body_offset = 0
    if lines[1] and lines[1]:match('^%-%-%-%s*$') then
      for i = 2, #lines do
        if lines[i]:match('^%-%-%-%s*$') then
          body_offset = i
          break
        end
      end
    end

    local changed = false
    for _, region in ipairs(content.expandable_regions) do
      local source = lines[region.block_id + body_offset] or ''
      -- 表の開始行を判別し、コードブロックなどの展開状態は変更しない。
      local is_table = source:match('^[%s>%d.)*+%-]*|')
          or source:lower():match('^[%s>%d.)*+%-]*<table[%s>]')
      if region.block_id > 0 and is_table and opts.expand_state[region.block_id] == nil then
        opts.expand_state[region.block_id] = true
        changed = true
      end
    end

    -- 明示的なfalseは保持して、クリックによる折り畳みを妨げない。
    if changed then
      return build_content(lines, opts)
    end
    return content
  end
end

return M
