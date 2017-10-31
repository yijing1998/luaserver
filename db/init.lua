local db = { cfg = nil }
package.loaded[...] = db

-- function: new
-- new routine, for object initiating or inheritance
function db:new()
  local o = {}
  self.__index = self
  setmetatable(o, self)
  return o
end

-- function: init
-- init db params
function db:init(cfg)
  self.cfg = cfg
  self:setup()
end

-- function: setup (virtual function)
-- do real work for database setup
-- inheriting class must overwrite the function
function db:setup()
  -- a virtual function for understanding
  -- like interface/virtual function definition
  -- do nothing, can be omitted
end