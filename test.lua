local scfg = {}
local pcfg = {}
local rcfg = {}

scfg.name = "srv.normal"
scfg.host = "*"
scfg.port = 2514
scfg.tmout = {}
scfg.tmout.server = 3
scfg.tmout.client = 3
scfg.tmout.select = 3
scfg.rbsize = 200

pcfg.name = "parser.relp"
pcfg.cfg = {}
pcfg.cfg.maxinstwb = 10 -- max instream write back times (prevent bad msg)

rcfg.name = "recipe.term"

local f = require("srvfactory")
local s = f.create(scfg, pcfg, rcfg)
s:start()