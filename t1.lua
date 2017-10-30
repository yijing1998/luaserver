local scfg = {}
local pcfg = {}
local rcfg = {}
local dbcfg = {}

-- server
scfg.name = "srv.normal"
scfg.cfg = {}
scfg.cfg.host = "*"
scfg.cfg.port = 2514
scfg.cfg.tmout = {}
scfg.cfg.tmout.server = 1
scfg.cfg.tmout.client = 1
scfg.cfg.tmout.select = 1
scfg.cfg.rbsize = 1000

-- parser
pcfg.name = "parser.relp"
pcfg.cfg = {}
pcfg.cfg.maxinstwb = 10

-- recipe (recipe.term)
rcfg.name = "recipe.term"

local f = require("srvfactory")
local s = f.create(scfg, pcfg, rcfg)
s:start()