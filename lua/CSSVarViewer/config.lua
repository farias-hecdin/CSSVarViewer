local M = {}

-- Options table with default values
M.options = {
  parent_search_limit = 5,-- <number> Parent search limit (number of levels to search upwards).
  filename_to_track = "main", -- <string> Name of the file to track (e.g. "main" for main.css).
  disable_keymaps = false, -- <boolean> Indicates whether keymaps are disabled.
}

return M
