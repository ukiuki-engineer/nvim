local M = {}

function M.timer_start(time)
  vim.fn.timer_start(
    time,
    function()
      M.lua_add()
    end
  )
end

function M.lua_add()
  local bufferline = require('bufferline')
  bufferline.setup({
    options = {
      show_tab_indicators = true,
      buffer_close_icon = '×',
      style_preset = bufferline.style_preset.no_italic,
      numbers = function(opts)
        return string.format('%s.%s', opts.lower(opts.id), opts.lower(opts.ordinal))
      end,
      diagnostics = "coc",
      diagnostics_indicator = function(count, level)
        local icon = level:match("error") and " " or " "
        return " " .. icon .. count
      end,
    },
    highlights = {
      tab_selected = {
        fg = vim.g['colors_name'] == 'gruvbox' and '#ECE0BF' or '',
      },
    }
  })
end

return M
