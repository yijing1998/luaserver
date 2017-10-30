-- lua module: recipe.rawlog_db
-- store log msg in a database without modification
-- log msg: a serial characters with or without '\n' ending
local o = require("recipe")
local rawlog_db = o:new()
package.loaded[...] = rawlog_db

-- config file settings
-- cfg.db = ? -> database object
-- cfg.maxtmcounts = 20 -> buffered info existance threshold: by time
-- cfg.maxqucounts = 5 -> buffered info existance threshold: by queue depth

local infocache = {}
local lasttmcheckpoint = os.time()
-- function: cook
-- recipe cook: store info in a database
-- record time elapsed and info queue depth until threshold
-- do batch SQL to reduce database open/close operations
function rawlog_db:cook(info)
  local maxtmcounts = self.cfg.maxtmcounts
  local maxqucounts = self.cfg.maxqucounts
  local db = self.cfg.db
  local tmnow = os.time()

  infocache[#infocache + 1] = info
  
  -- do batch SQL
  -- use conn:escape() to escape special characters
  if tmnow - lasttmcheckpoint >= maxtmcounts or #infocache >= maxqucounts then
    lasttmcheckpoint = tmnow
    local conn = db:start()
    local tmpstr = ""
    if conn then
      for i = 1, #infocache do
        -- remove trailing '\n'
        tmpstr = string.gsub(infocache[i], "\n$", "")
        db:dummyexec(conn, string.format("insert into rawlog (rlog) values ('%s')", conn:escape(tmpstr)))
      end
      db:stop(conn)
    end
    infocache = {}
  end
end