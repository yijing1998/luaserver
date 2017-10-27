local o = require("db")
local sqlite3 = o:new()
package.loaded[...] = sqlite3

function sqlite3:setup()
  local driver = require("luasql.sqlite3")
  local env = driver and driver.sqlite3()
  self.cfg.env = env
end

function sqlite3:start()
  local env = self.cfg.env
  local connstr = self.cfg.connstr
  conn = env:connect(connstr)
  return conn
end

function sqlite3:stop(conn)
  conn:close()
end

function sqlite3:dummyexec(conn, sql)
  conn:execute(sql)
end