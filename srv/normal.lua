-- lua module: srv.normal
-- a tcp server for msg receiving, handling and sending

local o = require("srv")
local normal = o:new()
package.loaded[...] = normal

-- function: start
-- msg handling: receive msg, parse msg and send back msg
function normal:start()
  local server = self.cfg.server
  local tmout = self.cfg.tmout
  if not server then
    return
  end

  local socket = require("socket")
  local tb_cli = {}
  local tb_inst = {}
  local tb_outst = {}
  local tb_cli_closed = {}
  -- run forever
  while 1 do
    -- waiting for a client
    local cli, err = server:accept()
    if err then
      --print("accept:" .. err)
    end

    -- save client info
    if cli then
      self:saveclient(cli, tb_cli, tb_inst, tb_outst)
    end

    -- receive from clients
    -- and find out closed clients
    -- and parse received data to form sendback data
    -- and send sendback data
    if #tb_cli > 0 then
      tb_tmp1, tb_tmp2, err = socket.select(tb_cli, tb_cli, tmout.select)
      if err then
        --print("select:" .. err)
      else
        tb_cli_closed = self:batchreceive(tb_tmp1, tb_inst)

        -- parse received data
        if #tb_tmp1 > 0 then
          self:batchparse(tb_tmp1, tb_inst, tb_outst)
        end

        -- send back sendback data
        if #tb_tmp2 > 0 then
          self:batchsend(tb_tmp2, tb_outst)
        end
      end
    end

    -- remove closed client
    -- will clear tb_cli_closed
    if #tb_cli_closed > 0 then
      tb_cli = self:rmclosedcli(tb_cli, tb_cli_closed, tb_inst, tb_outst)
    end
  end
end