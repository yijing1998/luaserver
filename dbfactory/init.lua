-- lua module: dbfactory
-- produce a database object with proper configs

local dbfactory = {}
package.loaded[...] = dbfactory

function dbfactory.create(dbcfg)
  local d = require(dbcfg.name):new()
  d:init(dbcfg.cfg)
  return d
end