-- lua module: srvfactory
-- produce a server with proper configs

local srvfactory = {}
package.loaded[...] = srvfactory

function srvfactory.create(servercfg, parsercfg, recipecfg)
  local s = require(servercfg.name):new()
  local p = require(parsercfg.name):new()
  local r = require(recipecfg.name):new()
  p:init(r, parsercfg.cfg)
  s:init(servercfg.host, servercfg.port, servercfg.tmout, servercfg.rbsize, p)
  return s
end