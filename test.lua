stream = require("stream")
inst = stream:new()

term = require("recipe.term")
t = term:new()

simpleline = require("parser.simpleline")
line = simpleline:new()
line:init(t)

inst:write("abcdefg\n")
inst:write("1234567")
inst:write("hijklmn\n")

line:parse(inst)


local host, port = "*", 514
local tmout = { server = 3, client = 3, select = 3 }
local rbs = 1000
local noreply = require("srv.noreply")
local s = noreply:new()
s:init(host, port, tmout, rbs, "parser.simpleline", "recipe.term")
s:start()


