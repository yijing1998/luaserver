-- lua module: recipe
-- prototype class, do with the info extracted from instream
-- (show in terminal, save to file or db, or else)

local recipe = {}
package.loaded[...] = recipe

-- function: new routine, for inheritance
function recipe:new()
  local o = {}
  self.__index = self
  setmetatable(o, self)
  return o
end

-- function: init recipe params
function recipe:init(cfg)
  self.cfg = cfg
end

-- function: do real work for msg recipe
-- inherit class must overwrite the function
function recipe:cook(info)
  -- a virtual function for understanding
  -- like interface/virtual function definition
  -- do nothing
end