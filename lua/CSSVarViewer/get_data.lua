local M = {}
local fos = require('CSSVarViewer.file_ops')

local extract_key_value = function(data)
  local key, value = data:match("([-_%w]+)%s*:%s*([^;]+)")
  return key, value:gsub("^%s+", ""):gsub("%s+$", "")
end

M.get_css_attribute = function(fpath, properties)
  local content = fos.open_file(fpath)
  local captured_data = fos.extract_from_file(content, "[-_%w]+%s*:%s*[^;]+")

  local key_value_pairs = {}
  for _, data in ipairs(captured_data) do
    local key, value = extract_key_value(data)
    if key:match(properties) then
      key_value_pairs[key] = value
    end
  end
  return key_value_pairs
end

return M
