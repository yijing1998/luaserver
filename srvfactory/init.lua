-- lua module: srvfactory
-- produce a server with proper configs

local srvfactory = {}
package.loaded[...] = srvfactory

-- function: create
-- create a server with config files
function srvfactory.create(servercfg, parsercfg, recipecfg)
  local s = require(servercfg.name):new()
  local p = require(parsercfg.name):new()
  local r = require(recipecfg.name):new()
  r:init(recipecfg.cfg)
  parsercfg.cfg.recipe = r
  p:init(parsercfg.cfg)
  s:init(servercfg.cfg, p)
  return s
end