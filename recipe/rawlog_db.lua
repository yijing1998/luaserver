-- lua module: recipe.rawlog_db
-- store info in a database
local o = require("recipe")
local rawlog_db = o:new()
package.loaded[...] = rawlog_db

-- config file settings
-- cfg.db = db -> database object
-- cfg.maxtmcounts = 20 -> buffered info existance threshold: by time
-- cfg.maxqucounts = 5 -> buffered info existance threshold: by queue depth

local infocache = {}
local lasttmcheckpoint = os.time()
-- function cook
-- record time elapse and queue depth
-- do batch SQL to reduce database open/close operations
function rawlog_db:cook(info)
  local maxtmcounts = self.cfg.maxtmcounts
  local maxqucounts = self.cfg.maxqucounts
  local db = self.cfg.db
  local tmnow = os.time()

  infocache[#infocache + 1] = info
  
  -- do batch SQL
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