-- lua module: parser.simpleline
-- parse data line by line without reply

local o = require("parser")
local simpleline = o:new()
package.loaded[...] = simpleline

function simpleline:parse(inst)
  local rcp = self.rcp

  local data = inst:read()
  if #data == 0 then
    return
  end

  local i, j = string.find(data, ".-\n")
  local last = 0
  local info = ""
  while i do
    info = string.sub(data, i, j)
    if rcp and #info > 0 then
      rcp:cook(info)
    end
    last = j
    i, j = string.find(data, ".-\n", j + 1)
  end
  
  if last < #data then
    inst:write(string.sub(data, last + 1, -1))
  end
end