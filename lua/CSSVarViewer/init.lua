local M = {}
local vim = vim
local cfg = require('CSSVarViewer.misc.config')
local cph = require('CSSPluginHelpers')

local values_from_file = {}
local search_opts = {
  attempt_limit = "",
  filename = "",
  directory = ""
}

M.setup = function(options)
  cfg.options = vim.tbl_deep_extend("keep", options or {}, cfg.options)
  -- Enable keymap if they are not disableds
  if not cfg.options.disable_keymaps then
    local keymaps_opts = {buffer = 0, silent = true}
    -- Create the keymaps for the specified filetypes
    vim.api.nvim_create_autocmd('FileType', {
      desc = 'CSSVarViewer keymaps',
      pattern = 'css',
      callback = function()
        vim.keymap.set('n', '<leader>cv', ":CSSVarViewer<CR>", keymaps_opts)
      end,
    })
  end
  M.show_virtual_text()
end

--- Create a user command
vim.api.nvim_create_user_command("CSSVarViewer", function(args)
  if #(args.fargs[1] or "") > 1 then
    args.fargs[1], args.fargs[2], args.fargs[3] = 1, args.fargs[1], args.fargs[2]
  end

  search_opts.attempt_limit = tonumber(args.fargs[1] or cfg.options.parent_search_limit)
  search_opts.fname = (args.fargs[2] or cfg.options.filename_to_track) .. ".css"
  search_opts.fdir = args.fargs[3] or nil

  M.get_cssvar_from_file(search_opts.attempt_limit, search_opts.fname, search_opts.fdir)
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
M.show_virtual_text = function()
  -- Change filtype format from "*.css" to "css"
  local filetypes = {}
  for _, filetype in ipairs(cfg.options.filetypes) do
    table.insert(filetypes, "*" .. filetype)
  end
  -- Create an autocomman to call the M.create_virtual_text() function
  vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter", "CursorMoved", "CursorMovedI"}, {
    pattern = filetypes,
    callback = function()
      M.create_virtual_text()
    end,
  })
end

--- Creates a virtual text for CSS variables
M.create_virtual_text = function()
  local namespace = vim.api.nvim_create_namespace("cssvarviewer")
  local virtual_text = {}

  local line, line_content = cph.get_current_line_content()
  for captured_cssvar in line_content:gmatch('var%(%-%-[-_%w]*%)') do
    local value = values_from_file[captured_cssvar:match('%((%-%-.+)%)')]
    table.insert(virtual_text, value)
  end
  -- Show the virtual text in the buffer
  cph.show_virtual_text(virtual_text, line, namespace)
end

return M
