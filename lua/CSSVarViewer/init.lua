local M = {}
local gdt = require('CSSVarViewer.get_data')
local cfg = require('CSSVarViewer.config')
local fos = require('CSSVarViewer.file_ops')
local stx = require('CSSVarViewer.select_text')
local vrt = require('CSSVarViewer.virtual_text')

-- Cached variable
local g_valuesFromFile = {}
local g_lastFile, g_lastDir = nil, nil
local g_isPluginInitialized = false

M.setup = function(options)
  cfg.options = vim.tbl_deep_extend("keep", options or {}, cfg.options)
  -- Enable keymap if they are not disableds
  if not cfg.options.disable_keymaps then
    local keymaps_opts = {buffer = 0, silent = true}
    vim.api.nvim_create_autocmd('FileType', {
      desc = 'CSSVarViewer keymaps',
      callback = function()
        vim.keymap.set('n', '<leader>cv', ":lua require('CSSVarViewer').toggle()<CR>", keymaps_opts)
        vim.keymap.set('v', '<leader>cv', ":lua require('CSSVarViewer').paste_value()<CR>", keymaps_opts)
      end,
    })
  end
end

--- Toggle plugin
M.toggle = function() vim.cmd('CSSVarViewer') end

--- Analyze the arguments provided
local function parse_args(args)
  local attempt_limit = tonumber(cfg.options.parent_search_limit) - 1
  local fname = g_lastFile or cfg.options.filename_to_track
  local fdir = g_lastDir or nil

  local num_args = #args.fargs

  if num_args > 0 then
    local arg1, numArg1 = args.fargs[1], tonumber(arg1)
    if numArg1 then
      attempt_limit = numArg1
    else
      fname = arg1
    end
  end

  if num_args > 1 then
    local arg2 = args.fargs[2]
    if string.match(arg2, '^%d+$') then
      attempt_limit = tonumber(arg2) < 0 and 0 or tonumber(arg2)
      fdir = nil
    else
      fdir = arg2
      attempt_limit = 0
    end
  end

  return attempt_limit, fname, fdir
end

--- Show the virtual text in the buffer
local display_virtual_text = function()
  local get_css_variables = function(namespace)
    local variables = {}
    local line, line_content = vrt.get_current_line_content()

    for captured_variable in line_content:gmatch('var%(%-%-[-_%w]*%)') do
      local value = g_valuesFromFile[captured_variable:match('%((%-%-.+)%)')]
      table.insert(variables, value)
    end
    -- Show the virtual text in the buffer
    vrt.show_virtual_text(variables, line, namespace)
  end

  local namespace = vim.api.nvim_create_namespace("cssvarviewer")
  -- Create an autocommand to call the M.create_virtual_text() function
  vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter", "CursorMoved", "CursorHold"}, {
    pattern = "*.css",
    callback = function()
      vim.schedule(function()
        get_css_variables(namespace)
      end)
    end,
  })
  vim.print("[CSSVarViewer] The data has been updated. " .. os.date("%H:%M:%S"))
end

--- Paste the value at the cursor selection
M.paste_value = function()
  local pos_text, select_text = stx.capture_visual_selection()

  for key, value in pairs(g_valuesFromFile) do
    if select_text and key == select_text[1]:match('%((%-%-.+)%)') then
      select_text[1] = value
      vim.print(string.format("[CSSVarViewer] You replaced '%s' with '%s'.", key, value))
      stx.change_text(pos_text, select_text)
    end
  end
end

--- Create a user command
vim.api.nvim_create_user_command("CSSVarViewer", function(args)
  local attempt_limit, fname, fdir = parse_args(args)
  g_lastFile, g_lastDir = fname, fdir

  local data = M.get_cssvar_from_file(attempt_limit, fname .. ".css", fdir)
  if not data then
    return
  end
  display_virtual_text()

  -- Event to auto-reload the data
  if g_isPluginInitialized then
    vim.api.nvim_create_autocmd({"BufWritePost"}, {
      pattern = "*.css",
      callback = function()
        vim.cmd('CSSVarViewer')
      end,
    })
  end
end, {desc = "Track the values of the CSS variables", nargs = "*"})

--- Gets CSS variables from a file
M.get_cssvar_from_file = function(attempt_limit, fname, fdir)
  local fpath = fos.find_file(fname, fdir, 1, attempt_limit)
  if not fpath then
    vim.print("[CSSVarViewer] Attempt limit reached. Operation cancelled.")
    return false
  end
  -- Extract CSS attributes (variables) from the file
  local data = gdt.get_css_attribute(fpath, "%-%-[-_%w]*")
  g_valuesFromFile = data
  g_isPluginInitialized = true
  return true
end

return M
