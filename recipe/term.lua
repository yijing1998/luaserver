-- lua module: recipe.term
-- show info in terminal

local o = require("recipe")
local term = o:new()
package.loaded[...] = term

-- config file settings
-- need no config file

-- function: cook
-- recipe cook: show info in terminal
function term:cook(info)
  print(info)
end