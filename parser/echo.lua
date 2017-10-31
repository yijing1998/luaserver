-- lua module: parser.echo
-- echo parse, read data from instream and write the data to outstream without modification

local o = require("parser")
local echo = o:new()
package.loaded[...] = echo

-- config file settings
-- cfg.recipe = ? -> recipe object used when parsing

-- function: parse
-- data mirror from instream to outstream and passing them to the recipe
function echo:parse(inst, outst)
    if not inst then
      return
    end
  
    local recipe = self.cfg.recipe
    info = inst:read()
    if recipe and #info > 0 then
      recipe:cook(info)
    end

    if outst and #info > 0 then
      outst:write(info)
    end
  end