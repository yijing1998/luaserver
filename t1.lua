local f = require("objfactory")

-- db
local dbcfg = {}
dbcfg.connstr = "../database/syslog-sqlite3.db"
local db = f.create("db.sqlite3", dbcfg)

-- recipe.rawlog_db
local rcfg = {}
rcfg.db = db
rcfg.maxtmcounts = 20
rcfg.maxqucounts = 5
local r = f.create("recipe.rawlog_db", rcfg)

-- recipe.term
-- local r = f.create("recipe.term", nil)

-- parser.relp
local pcfg = {}
pcfg.recipe = r
pcfg.maxinstwb = 10
local p = f.create("parser.relp", pcfg)

-- server
local scfg = {}
scfg.host = "*"
scfg.port = 2514
scfg.tmout = {}
scfg.tmout.server = 1
scfg.tmout.client = 1
scfg.tmout.select = 1
scfg.rbsize = 1000
scfg.parser = p
local s = f.create("srv.normal", scfg)

s:start()