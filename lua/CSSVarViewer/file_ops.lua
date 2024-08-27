local M = {}

--- Search for the file "*.css" in the current directory and parent directories.
M.find_file = function(fname, dir, attempt, limit)
  if not attempt or attempt > limit then
    return false
  end

  dir = dir or ""
  local handle = io.popen("ls -1 " .. dir)
  if not handle then
    return false
  end

  local isAttemptOne = (attempt == 1)
  for file in handle:lines() do
    if file == fname then
      handle:close()
      return dir .. (isAttemptOne and fname or "/" .. fname)
    end
  end
  handle:close()

  dir = dir .. "../"
  return M.find_file(fname, dir, attempt + 1, limit)
end

--- Open a file and return its contents
M.open_file = function(fpath)
  local file = io.open(fpath, "r")
  if not file then
    return
  end

  local contents = {}
  for line in file:lines() do
    table.insert(contents, line)
  end

  file:close()
  return contents
end

-- Capture file data
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
