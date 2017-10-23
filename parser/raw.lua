-- lua module: parser.raw
-- raw parse, just read from instream without reply

local o = require("parser")
local raw = o:new()
package.loaded[...] = raw

function raw:doparse(inst)
  local rcp = self.rcp
  
  if not inst then
    return
  end

  info = inst:read()
  if rcp and #info > 0 then
    rcp:cook(info)
  end
end