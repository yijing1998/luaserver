local db = { cfg = nil }
package.loaded[...] = db

function db:new()
  local o = {}
  self.__index = self
  setmetatable(o, self)
  return o
end

function db:init(cfg)
  self.cfg = cfg
  self:setup()
end

function db:setup()
  -- do nothing
end