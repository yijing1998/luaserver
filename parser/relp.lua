-- lua module: parser.relp
-- implement of rsyslog's relp (server side)

local o = require("parser")
local relp = o:new()
package.loaded[...] = relp

function relp:parse(inst, outst)
  local rcp = self.rcp
  
  local data = inst:read()
  if #data == 0 then
    return
  end

  -- header parse
  local i, j = string.find(data, "^%d+ %a+ %d+%s*")
  local txnr, cmd, datalen = nil, nil, nil
  local tmpstr = nil
  while i do
    txnr, cmd, datalen = string.match(string.sub(data, i, j), "(%d+) (%a+) (%d+)%s*")
    datalen = tonumber(datalen)
    -- check if the whole cmd is received
    if j + datalen + 1 > #data then
      -- partial cmd, write back and wait for more
      print("partial cmd")
      inst:write(data)
      return
    end

    -- cmd parse
    print(cmd)
    if cmd == "open" then
      tmpstr = string.format("200 ok\n%s", string.sub(data, j + 1, j + 1 + datalen))
      outst:write(txnr .. " rsp " .. #tmpstr .. " ")
      outst:write(tmpstr .. "\n")
    elseif cmd == "syslog" then
      tmpstr = string.format("200 ok")
      outst:write(txnr .. " rsp " .. #tmpstr .. " ")
      outst:write(tmpstr .. "\n")

      if self.rcp then
        self.rcp:cook(string.sub(data, j + 1, j + 1 + datalen))
      end
    else
      print("others")
    end

    -- parse next cmd
    data = string.sub(data, j + datalen + 2, -1)
    i, j = string.find(data, "^%d+ %a+ %d+%s*")
  end
end