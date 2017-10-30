-- lua module: parser
-- define a framework for parsing data
-- 1. parse data from instream
-- 2. extract info according to 1, and recipe them
-- 3. form reply to outstream for further communication

local parser = { rcp = nil, cfg = nil }
package.loaded[...] = parser

-- function: new
-- new routine, for object initiating or inheritance
function parser:new()
  local o = {}
  self.__index = self
  setmetatable(o, self)
  return o
end

-- function: init
-- init parser params
function parser:init(cfg)
  self.cfg = cfg
end

-- function: parse (virtual function)
-- do real work for stream parsing
-- inheriting class must overwrite the function
function parser:parse(inst, outst)
  -- a virtual function for understanding
  -- like interface/virtual function definition
  -- do nothing, can be omitted
end