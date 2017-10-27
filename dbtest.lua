local dbcfg = {}
dbcfg.name = "db.sqlite3"
dbcfg.cfg = {}
dbcfg.cfg.connstr = "../database/syslog-sqlite3.db"

local f = require("dbfactory")
local db = f.create(dbcfg)

local sql = "insert into rawlog (rlog) values ('abc')"
local conn = db:start()
if conn then
  db:dummyexec(conn, sql)
  db:stop(conn)
end

