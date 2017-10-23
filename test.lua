local host, port = "*", 2514
local tmout = { server = 3, client = 3, select = 3 }
local rbsize = 1000
local normal = require("srv.normal")
local s = normal:new()
--local noreply = require("srv.noreply")
--local s = noreply:new()
s:init(host, port, tmout, rbsize, "parser.relp", nil)
s:start()


