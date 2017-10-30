-- lua module: recipe.term
-- show info in terminal

local o = require("recipe")
local term = o:new()
package.loaded[...] = term

-- function: recipe handling
-- show info in terminal
function term:cook(info)
  print(info)
end