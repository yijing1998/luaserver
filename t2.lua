local f = require("objfactory")

-- recipe.term
local r = f.create("recipe.term", nil)

-- parser.echo
local pcfg = {}
pcfg.recipe = r
local p = f.create("parser.echo", pcfg)

-- server
local scfg = {}
scfg.host = "*"
scfg.port = 8888
scfg.tmout = {}
scfg.tmout.server = 1
scfg.tmout.client = 1
scfg.tmout.select = 1
scfg.rbsize = 1000
scfg.parser = p
local s = f.create("srv.normal", scfg)

s:start()