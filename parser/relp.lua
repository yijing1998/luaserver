-- lua module: parser.relp
-- implement of rsyslog's relp (server side)

local o = require("parser")
local relp = o:new()
package.loaded[...] = relp

function relp:doparse(inst, outst)
  local rcp = self.rcp
  
  local data = inst:read()
  if #data == 0 then
    return
  end

  -- header parse
  local i, j = string.find(data, "^%d+ %a+ %d+")
  local txnr, cmd, datalen = nil, nil, nil
  local tmpstr = nil
  while i do
    txnr, cmd, datalen = string.match(string.sub(data, i, j), "(%d+) (%a+) (%d+)")
    -- check if the whole cmd is received
    if j + datalen + 1 > #data then
      -- partial cmd, write back and wait for more
      inst:write(data)
      return
    end

    -- cmd parse
    print("cmd:" .. cmd)
    if cmd == "open" then
      print("open offer:" .. string.sub(data, j + 1, -1))
      tmpstr = "\nrelp_version 1"
      outst:write(txnr .. "rsp" .. #tmpstr .. "\n")
      outst:write(tmpstr)
    else cmd == "syslog" then
      print("syslog")
    else
      print("others")
    end

    -- parse next cmd
    data = string.sub(data, j + datalen + 2, -1)
    i, j = string.find(data, "^%d+ %a+ %d+")
  end
end