local o = require("db")
local sqlite3 = o:new()
package.loaded[...] = sqlite3

-- function: setup
-- setup db.sqlite3 and get env object
function sqlite3:setup()
  local driver = require("luasql.sqlite3")
  local env = driver and driver.sqlite3()
  self.cfg.env = env
end

-- function: start
-- get conn object and escape function
function sqlite3:start()
  local env = self.cfg.env
  local connstr = self.cfg.connstr
  conn = env:connect(connstr)
  return conn, conn.escape
end

-- function: stop
-- close conn object
function sqlite3:stop(conn)
  conn:close()
end

-- function: dummyexec
-- execute SQL without any result
function sqlite3:dummyexec(conn, sql)
  conn:execute(sql)
end