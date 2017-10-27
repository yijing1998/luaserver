local scfg = {}
local pcfg = {}
local rcfg = {}
local dbcfg = {}

-- server
scfg.name = "srv.normal"
scfg.host = "*"
scfg.port = 2514
scfg.tmout = {}
scfg.tmout.server = 3
scfg.tmout.client = 3
scfg.tmout.select = 3
scfg.rbsize = 1000

-- parser
pcfg.name = "parser.relp"
pcfg.cfg = {}
pcfg.cfg.maxinstwb = 10 -- max instream write back times (prevent bad msg)

-- database
dbcfg.name = "db.sqlite3"
dbcfg.cfg = {}
dbcfg.cfg.connstr = "../database/syslog-sqlite3.db"
local db = require("dbfactory").create(dbcfg)

-- recipe (recipe.term)
-- rcfg.name = "recipe.term"

-- recipe (recipe.rawlog_db)
rcfg.name = "recipe.rawlog_db"
rcfg.cfg = {}
rcfg.cfg.db = db
rcfg.cfg.maxtmcounts = 20
rcfg.cfg.maxqucounts = 5

local f = require("srvfactory")
local s = f.create(scfg, pcfg, rcfg)
s:start()