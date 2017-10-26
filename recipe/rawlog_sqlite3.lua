-- lua module: recipe.rawlog_sqlite3
-- store info in a sqlite3 file

local o = require("recipe")
local rawlog_sqlite3 = o:new()
package.loaded[...] = rawlog_sqlite3

-- cook: record time elapse and cached info
-- do batchcook to reduce database open/close times