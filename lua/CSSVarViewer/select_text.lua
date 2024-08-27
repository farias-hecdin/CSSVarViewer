local M = {}

--- Select text in Visual Mode
-- (thanks to: https://github.com/antonk52/markdowny.nvim)

-- to get the line at the given line number
local get_line = function(line_num)
  return vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]
end

-- to get the position of the given mark
local get_mark = function(mark)
  local position = vim.api.nvim_buf_get_mark(0, mark)
  return { position[1], position[2] + 1 }
end

-- to get the first byte of the character at the given position
local get_first_byte = function(pos)
  local byte = string.byte(get_line(pos[1]):sub(pos[2], pos[2]))
  if not byte then
    return pos
  end

  while byte >= 0x80 and byte < 0xc0 do
    pos[2] = pos[2] - 1
    byte = string.byte(get_line(pos[1]):sub(pos[2], pos[2]))
  end
  return pos
end

-- to get the last byte of the character at the given position
local get_last_byte = function(pos)
  if not pos then
    return nil
  end

  local byte = string.byte(get_line(pos[1]):sub(pos[2], pos[2]))
  if not byte then
    return pos
  end

  if byte >= 0xf0 then
    pos[2] = pos[2] + 3
  elseif byte >= 0xe0 then
    pos[2] = pos[2] + 2
  elseif byte >= 0xc0 then
    pos[2] = pos[2] + 1
  end
  return pos
end

-- to get the text between the given selection
local get_text = function(selection)
  local first_pos, last_pos = selection.first_pos, selection.last_pos
  last_pos[2] = math.min(last_pos[2], #get_line(last_pos[1]))
  return vim.api.nvim_buf_get_text(0, first_pos[1] - 1, first_pos[2] - 1, last_pos[1] - 1, last_pos[2], {})
end

--- Capture the currently selected text
M.capture_visual_selection = function()
  local s = get_first_byte(get_mark('<'))
  local e = get_last_byte(get_mark('>'))

  if s == nil or e == nil then
    return
  end
  if vim.fn.visualmode() == 'V' then
    e[2] = #get_line(e[1])
  end

  local selection = {first_pos = s, last_pos = e}
  local text = get_text(selection)

  return selection, text
end

--- Change the text at the given selection
M.change_text = function(selection, text)
  if not selection then
    return
  end
  local first_pos, last_pos = selection.first_pos, selection.last_pos
  vim.api.nvim_buf_set_text(0, first_pos[1] - 1, first_pos[2] - 1, last_pos[1] - 1, last_pos[2], text)
end

return M
