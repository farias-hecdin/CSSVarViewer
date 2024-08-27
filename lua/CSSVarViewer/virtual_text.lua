local M = {}

--- Get the content of the current line
M.get_current_line_content = function()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local line_content = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]

  return line, line_content
end

-- Thanks to: https://github.com/jsongerber/nvim-px-to-rem
M.show_virtual_text = function(virtual_text, current_line, namespace, style)
  local extmark = vim.api.nvim_buf_get_extmark_by_id(0, namespace, namespace, {})
  if extmark ~= nil then
    vim.api.nvim_buf_del_extmark(0, namespace, namespace)
  end
  -- Create extmark if virtual text is present
  if #virtual_text > 0 then
    vim.api.nvim_buf_set_extmark(0, tonumber(namespace), (current_line - 1), 0,
      {
        virt_text = { {table.concat(virtual_text, " "), style or "Comment"} },
        id = namespace,
        priority = 100,
      }
    )
  end
end

return M
