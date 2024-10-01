local M = {}

local escape_shell_arg = function(arg)
  return "'" .. arg:gsub("'", "'\\''") .. "'"
end

--- Search for the file "*.css" in the current directory and parent directories.
M.find_file = function(fname, dir, attempt, limit)
  dir = dir or "./"

  if dir:sub(-1) ~= "/" then dir = dir .. "/" end

  if attempt > limit then return false end

  local escaped_dir = escape_shell_arg(dir)
  local handle = io.popen("ls -1 " .. escaped_dir .. " 2>/dev/null")
  if not handle then return false end

  for file in handle:lines() do
    if file == fname then
      handle:close()
      return dir .. (attempt == 1 and fname or "/" .. fname)
    end
  end
  handle:close()

  return M.find_file(fname, dir .. "../", attempt + 1, limit)
end

--- Open a file and return its contents
M.open_file = function(fpath)
  local file = io.open(fpath, "r")
  if not file then return end

  local contents = {}
  for line in file:lines() do
    table.insert(contents, line)
  end

  file:close()
  return contents
end

--- Capture file data
M.extract_from_file = function (content, pattern)
  local captured_data = {}

  for _, line in ipairs(content) do
    for data in string.gmatch(line, pattern) do
      table.insert(captured_data, data)
    end
  end
  return captured_data
end

return M
