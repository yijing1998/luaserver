local o = require("db")
local sqlite3 = o:new()
package.loaded[...] = sqlite3

function sqlite3:setup()
  local driver = require("luasql.sqlite3")
  local env = driver and driver.sqlite3()
  self.cfg.env = env
end