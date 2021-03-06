-- lua module: parser.relp
-- implement of rsyslog's relp (server side)

local o = require("parser")
local relp = o:new()
package.loaded[...] = relp

-- config file settings
-- cfg.recipe = ? -> recipe object used when parsing
-- cfg.maxinstwb = 10 -> max write back counts (when can't find a proper relp header)

local instwb = 0 -- record the current instream write back counts

-- do with regular expression for different lua version
local findstr = {}
local selfindstr = {}
findstr.v51 = {}
findstr.v53 = {}
findstr.v53.a = "%d+ %a+ %d+%s*"
findstr.v53.b = "^(%d+) (%a+) (%d+)%s*"

if string.find(_G._VERSION, "Lua 5.3") then
  selfindstr = findstr.v53
else
  selfindstr = findstr.v51
end

-- function: secfilter
-- filter data from instream and find a proper relp header
-- if no proper header found, write the data back to instream and wait for more data coming
-- if write back counts exceed the threshold, data from instream will be discarded
local function secfilter(data, inst, maxinstwb)
  local i, j = 0, 0
  local data = data
  if #data == 0 then
    return nil
  end

  i, j = string.find(data, selfindstr.a)
  if i == nil then
    -- print("bad message1:", instwb, data)
    if instwb <= maxinstwb then
      inst:write(data)
      instwb = instwb + 1
    else
      inst:clear()
    end
    return nil
  end

  if i ~= 1 then
    -- print("bad message2:", instwb, string.sub(data, 1, i - 1))
    -- print("bad message whole:", data)
    data = string.sub(data, i, -1)
  end

  return data, 1, j - i + 1
end

-- function: parse
-- implement of rsyslog's relp (server side)
-- parse data from instream, logs go to recipe and write response data to outstream
function relp:parse(inst, outst)
  local data = inst:read()
  if #data == 0 then
    return
  end

  local recipe = self.cfg.recipe

  -- header parse
  instwb = 0
  local maxinstwb = self.cfg.maxinstwb
  local i, j = 0, 0
  local txnr, cmd, datalen = 0, "", 0
  local tmpstr = ""
  data, i, j = secfilter(data, inst, maxinstwb)
  while data do
    txnr, cmd, datalen = string.match(data, selfindstr.b)
    datalen = tonumber(datalen)
    -- check if the whole cmd is received
    if j + datalen + 1 > #data then
      -- partial cmd, write back and wait for more
      -- print("partial cmd")
      inst:write(data)
      return
    end

    -- cmd parse
    if cmd == "open" then
      tmpstr = string.format("200 ok\n%s", string.sub(data, j + 1, j + 1 + datalen))
      outst:write(txnr .. " rsp " .. #tmpstr .. " ")
      outst:write(tmpstr .. "\n")
    elseif cmd == "syslog" then
      tmpstr = string.format("200 ok")
      outst:write(txnr .. " rsp " .. #tmpstr .. " ")
      outst:write(tmpstr .. "\n")
      -- print("response txnr:", txnr)
      if recipe then
        recipe:cook(string.sub(data, j + 1, j + 1 + datalen))
      end
    else
      print("others")
    end

    -- parse next cmd
    data = string.sub(data, j + datalen + 2, -1)
    data, i, j = secfilter(data, inst, maxinstwb)
  end
end