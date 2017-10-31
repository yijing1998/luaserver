-- lua module: objfactory
-- produce an object with proper configs

local objfactory = {}
package.loaded[...] = objfactory

-- function: create
-- create an object with module name and config table
function objfactory.create(mname, cfg)
  local o = require(mname):new()
  o:init(cfg)
  return o
end