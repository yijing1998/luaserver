-- lua module: stream
-- do with a string stream(in or out) based on lua api: table.concat()

local stream = { data = nil }
package.loaded[...] = stream

function stream:new()
  local o = {}
  self.__index = self
  setmetatable(o, self)
  o.data = {}
  return o
end

-- write a string to the stream
function stream:write(data)
  self.data[#self.data + 1] = data
end

-- read all from the stream as a string
function stream:read()
  local ret = ""
  if #self.data > 0 then
    ret = table.concat(self.data)
    self.data = {}
  end
  return ret
end