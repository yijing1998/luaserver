local srv = { host = "", port = 0, tmout = {}, rbsize = 0, server = {}, parser = {} }
package.loaded[...] = srv

-- load for reference
local stream = require("stream")

-- function: new routine, for inheritance
function srv:new()
  local o = {}
  self.__index = self
  setmetatable(o, self)
  return o
end

-- function: init server params
-- input
-- tmout: table to store timeout values, tmout.server/client/select
-- rbs: max receive block size
function srv:init(host, port, tmout, rbsize, parser)
  self.host = host
  self.port = port
  self.tmout = tmout
  self.rbsize = rbsize
  local socket = require("socket")
  local ret, err = socket.bind(host, port)
  if ret then
    ret:settimeout(tmout.server)
    self.server = ret
  else
    self.server = nil
  end
  self.parser = parser
end

function srv:saveclient(cli, tb_cli, tb_inst, tb_outst)
  cli:settimeout(self.tmout.client)
  tb_cli[#tb_cli + 1] = cli
  if tb_inst then
    tb_inst[cli] = stream:new()
  end
  if tb_outst then
    tb_outst[cli] = stream:new()
  end
end

function srv:batchreceive(tb_cli_ready, tb_inst)
  local msg, err, pmsg = nil, nil, nil
  local tmpcli = nil
  local ret = {}
  for i = 1, #tb_cli_ready do
    tmpcli = tb_cli_ready[i]
    msg, err, pmsg = tmpcli:receive(self.rbsize)
    if err then
      tb_inst[tmpcli]:write(pmsg)
    else
      tb_inst[tmpcli]:write(msg)
    end
    if err == "closed" then
      ret[#ret + 1] = tmpcli
    end
  end
  return ret
end

-- send data with no buffer (send immediately)
-- undebug
function srv:batchsend(tb_cli_ready, tb_outst)
  local last, err, plast = nil, nil, nil
  local tmpcli = nil
  local msg = nil
  for i = 1, #tb_cli_ready do
    tmpcli = tb_cli_ready[i]
    msg = tb_outst[tmpcli]:read()
    if #msg > 0 then
      last, err, plast = tmpcli:send(msg)
      if err == nil then
        print("no error")
      elseif err == "timeout" then
        print("timeout")
      else
        -- closed
        print("closed")
      end
      -- save unsent msg

    end
  end
end

function srv:batchparse(tb_cli_ready, tb_inst, tb_outst)
  local tmpcli = nil
  for i = 1, #tb_cli_ready do
    tmpcli = tb_cli_ready[i]
    self.parser:parse(tb_inst and tb_inst[tmpcli], tb_outst and tb_outst[tmpcli])
  end
end

function srv:rmclosedcli(tb_cli, tb_cli_closed, tb_inst, tb_outst)
  local tb_ret = {}
  local flag = 0
  local tmpcli = nil
  for i = 1, #tb_cli do
    tmpcli = tb_cli[i]
    for j = 1, #tb_cli_closed do
      if tb_cli_closed[j] == tmpcli then
        table.remove(tb_cli_closed, j)
        flag = 1
        break
      end
    end
    if flag == 0 then
      tb_ret[#tb_ret + 1] = tmpcli
    else
      if tb_inst then
        tb_inst[tmpcli] = nil
      end
      if tb_outst then
        tb_outst[tmpcli] = nil
      end
      tmpcli:close()
      flag = 0
    end
  end
  return tb_ret
end

function srv:start()
  -- do nothing
end