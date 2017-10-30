-- lua module: recipe
-- prototype class, do with the info extracted from instream
-- (show in terminal, save to file or db, or else)

local recipe = {}
package.loaded[...] = recipe

-- function: new
-- new routine, for object initiating or inheritance
function recipe:new()
  local o = {}
  self.__index = self
  setmetatable(o, self)
  return o
end

-- function: init
-- init recipe params
function recipe:init(cfg)
  self.cfg = cfg
end

-- function: cook (virtual function)
-- do real work for info cooking
-- inheriting class must overwrite the function
function recipe:cook(info)
  -- a virtual function for understanding
  -- like interface/virtual function definition
  -- do nothing
end