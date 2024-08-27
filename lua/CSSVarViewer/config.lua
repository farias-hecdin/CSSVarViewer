local M = {}

-- Options table with default values
M.options = {
  -- <number> Parent search limit (number of levels to search upwards)
  parent_search_limit = 5,
  -- <string> Name of the file to track (e.g. "main" for main.css)
  filename_to_track = "main",
  -- <boolean> Indicates whether keymaps are disabled
  disable_keymaps = false,
}

return M
