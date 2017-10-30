-- lua module: parser.raw
-- raw parse, read data from instream without reply

local o = require("parser")
local raw = o:new()
package.loaded[...] = raw

-- config file settings
-- cfg.recipe = ? -> recipe object used when parsing

-- function: parse
-- read data from instream and passing them to the recipe
function raw:parse(inst)
  if not inst then
    return
  end

  local recipe = self.cfg.recipe
  info = inst:read()
  if recipe and #info > 0 then
    recipe:cook(info)
  end
end