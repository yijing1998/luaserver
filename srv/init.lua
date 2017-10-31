-- lua module: srv
-- prototype class for a tcp server

local srv = {}
package.loaded[...] = srv

-- load for reference
local stream = require("stream")

-- function: new
-- new routine, for object initiating or inheritance
function srv:new()
  local o = {}
  self.__index = self
  setmetatable(o, self)
  return o
end

-- config file settings
-- cfg.host = "*" -> host name or ip address
-- cfg.port = 514 -> socket listening port
-- cfg.tmout = {} -> socket timemout settings: tmout.server, tmout.client, tmout.select, for luasocket api parmeters settings such as select, settimeout
-- cfg.rbsize = 1000 -> socket receive block size

-- function: init
-- init server params
function srv:init(cfg)
  self.cfg = cfg
  local host = cfg.host
  local port = cfg.port
  local tmout = cfg.tmout
  local socket = require("socket")
  local ret, err = socket.bind(host, port)
  if ret then
    ret:settimeout(tmout.server)
    self.cfg.server = ret
  else
    self.cfg.server = nil
  end
end

-- function: saveclient
-- save accepted client into tables
-- tb_cli: array for accepted client socket
-- tb_inst: table for (socket, instream) pair
-- tb_outst: table for (socket, outstream) pair
function srv:saveclient(cli, tb_cli, tb_inst, tb_outst)
  cli:settimeout(self.cfg.tmout.client)
  tb_cli[#tb_cli + 1] = cli
  if tb_inst then
    tb_inst[cli] = stream:new()
  end
  if tb_outst then
    tb_outst[cli] = stream:new()
  end
end

-- function: batchreceive
-- batch receive msg from tb_cli_ready
-- tb_cli_ready: array for ready sockets
-- tb_inst: table for (socket, instream) pair
-- received msg is written into the respective instream according to the socket
function srv:batchreceive(tb_cli_ready, tb_inst)
  local rbsize = self.cfg.rbsize
  local msg, err, pmsg = nil, nil, nil
  local tmpcli = nil
  local ret = {}
  for i = 1, #tb_cli_ready do
    tmpcli = tb_cli_ready[i]
    msg, err, pmsg = tmpcli:receive(rbsize)
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

-- function: batchsend
-- batch send msg from tb_cli_ready
-- tb_cli_ready: array for ready sockets
-- tb_outst: table for (socket, outstream) pair
-- send msg immediately from the respective outstream according to the socket (no buffer)
function srv:batchsend(tb_cli_ready, tb_outst)
  local last, err, plast = nil, nil, nil
  local tmpcli = nil
  local msg = nil
  for i = 1, #tb_cli_ready do
    tmpcli = tb_cli_ready[i]
    msg = tb_outst[tmpcli]:read()
    if #msg > 0 then
      last, err, plast = tmpcli:send(msg)
      print(last, err, plast)
      if err == nil then
        -- print("no error")
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

-- function: batchparse
-- batch parse the received msg
-- parse msg from instream and write the result to outsteam
-- self.cfg.parser:parse() do the real work
function srv:batchparse(tb_cli_ready, tb_inst, tb_outst)
  local tmpcli = nil
  local parser = self.cfg.parser
  for i = 1, #tb_cli_ready do
    tmpcli = tb_cli_ready[i]
    parser:parse(tb_inst and tb_inst[tmpcli], tb_outst and tb_outst[tmpcli])
  end
end

-- function: rmclosedcli
-- remove closed socket and associated streams
-- tb_cli: array for sockets
-- tb_cli_closed: array for closed sockets
-- tb_inst: table for (socket, instream) pair
-- tb_outst: table for (socket, outstream) pair
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

-- function: start (virtual function)
-- do real work for msg handling
-- inheriting class must overwrite the function
function srv:start()
  -- a virtual function for understanding
  -- like interface/virtual function definition
  -- do nothing
end