local M = {}
local vim = vim
local cph = require('CSSPluginHelpers')
local values_from_file = {}
local filetypes = 'css'

-- Options table with default values
M.options = {
  -- <number> Parent search limit (number of levels to search upwards)
  parent_search_limit = 5,
  -- <string> Name of the file to track (e.g. "main" for main.css)
  filename_to_track = "main",
  -- <boolean> Indicates whether keymaps are disabled
  disable_keymaps = false,
}

M.setup = function(options)
  M.options = vim.tbl_deep_extend("keep", options or {}, M.options)
  -- Enable keymap if they are not disableds
  if not M.options.disable_keymaps then
    local keymaps_opts = {buffer = 0, silent = true}
    -- Create the keymaps for the specified filetypes
    vim.api.nvim_create_autocmd('FileType', {
      desc = 'CSSVarViewer keymaps',
      pattern = filetypes,
      callback = function()
        vim.keymap.set('n', '<leader>cv', ":CSSVarViewer<CR>", keymaps_opts)
        vim.keymap.set('v', '<leader>cv', ":lua require('CSSVarViewer').paste_value()<CR>", keymaps_opts)
      end,
    })
  end
end

--- Create a user command
vim.api.nvim_create_user_command("CSSVarViewer", function(args)
  if #(args.fargs[1] or "") > 1 then
    args.fargs[1], args.fargs[2], args.fargs[3] = 1, args.fargs[1], args.fargs[2]
  end

  local attempt_limit = tonumber(args.fargs[1] or M.options.parent_search_limit)
  local fname = (args.fargs[2] or M.options.filename_to_track) .. ".css"
  local fdir = args.fargs[3] or nil

  M.get_cssvar_from_file(attempt_limit, fname, fdir)
  M.display_virtual_text()
end, {desc = "Track the values of the CSS variables", nargs = "*"})

--- Gets CSS variables from a file
M.get_cssvar_from_file = function(attempt_limit, fname, fdir)
  local fpath = cph.find_file(fname, fdir, 1, attempt_limit)
  if not fpath then
    vim.print("[CSSVarHighlight] Attempt limit reached. Operation cancelled.")
    return
  end
  -- Extract CSS attributes (variables) from the file
  local data = cph.get_css_attribute(fpath, "%-%-[-_%w]*")
  values_from_file = data
end

--- Show the virtual text in the buffer
M.display_virtual_text = function()
  local function get_css_variables(namespace)
    local variables = {}
    local line, line_content = cph.get_current_line_content()

    for captured_variable in line_content:gmatch('var%(%-%-[-_%w]*%)') do
      local value = values_from_file[captured_variable:match('%((%-%-.+)%)')]
      table.insert(variables, value)
    end
    -- Show the virtual text in the buffer
    cph.show_virtual_text(variables, line, namespace)
  end

  local namespace = vim.api.nvim_create_namespace("cssvarviewer")
  -- Create an autocommand to call the M.create_virtual_text() function
  vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter", "CursorMoved"}, {
    pattern = filetypes,
    callback = function()
      get_css_variables(namespace)
    end,
  })
  vim.print("[CSSVarViewer] The data has been updated. ".. os.date("%H:%M:%S"))
end

--- Paste the value at the cursor selection
M.paste_value = function()
  local pos_text, select_text = cph.capture_visual_selection()
  for key, value in pairs(values_from_file) do
    if select_text and key == select_text[1]:match('%((%-%-.+)%)') then
      select_text[1] = value
      vim.print(string.format("[CSSVarViewer] You replaced '%s' with '%s'.", key, value))
      cph.change_text(pos_text, select_text)
    end
  end
end

return M
