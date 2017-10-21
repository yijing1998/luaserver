local o = require("srv")
local noreply = o:new()
package.loaded[...] = noreply

function noreply:start()
  if not self.server then
    return
  end

  local socket = require("socket")
  local tb_cli = {}
  local tb_inst = {}
  local tb_cli_closed = {}
  -- run forever
  while 1 do
    -- waiting for a client
    local cli, err = self.server:accept()
    if err then
      --print("accept:" .. err)
    end

    -- save client info
    if cli then
      self:saveclient(cli, tb_cli, tb_inst, nil)
    end

    -- receive from clients
    -- and find out closed clients
    -- and parse received data
    if #tb_cli > 0 then
      tb_tmp1, tb_tmp2, err = socket.select(tb_cli, nil, self.tmout.select)
      if err then
        --print("select:" .. err)
      else
        tb_cli_closed = self:batchreceive(tb_tmp1, tb_inst)

        -- parse received data
        if #tb_tmp1 > 0 then
          self:batchparse(tb_tmp1, tb_inst, nil)
        end
      end
    end

    -- remove closed client
    -- will clear tb_cli_closed
    if #tb_cli_closed > 0 then
      tb_cli = self:rmclosedcli(tb_cli, tb_cli_closed, tb_inst, nil)
    end
  end
end