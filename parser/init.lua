-- lua module: parser
-- define a framework for parsing data
-- 1. parse data from instream
-- 2. extract info according to 1, and recipe them
-- 3. form reply to outstream for further communication

local parser = { rcp = nil, cfg = nil }
package.loaded[...] = parser

function parser:new()
  local o = {}
  self.__index = self
  setmetatable(o, self)
  return o
end

function parser:init(rcp, cfg)
  self.rcp = rcp
  self.cfg = cfg
end

function parser:parse(inst, outst)
  -- a virtual function for understanding
  -- like interface/virtual function definition
  -- do nothing, can be omitted
end