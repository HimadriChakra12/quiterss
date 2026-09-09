-- =============================================================================
-- QuiteRSS — settings.lua
-- Main entry point. Loads all modules and merges them into one settings table.
-- This is the file LuaSettings reads from disk.
--
-- To customise: edit the individual files in conf.d/
-- To use a piece standalone: require("conf.d/appearance") etc.
-- =============================================================================

local function merge(dst, src)
  for k, v in pairs(src) do
    if type(v) == "table" and type(dst[k]) == "table" then
      merge(dst[k], v)
    else
      dst[k] = v
    end
  end
end

settings = {}

local modules = {
  require("conf.d.general"),
  require("conf.d.appearance"),
  require("conf.d.feeds"),
  require("conf.d.browser"),
  require("conf.d.network"),
  require("conf.d.notifications"),
  require("conf.d.cleanup"),
  require("conf.d.adblock"),
  require("conf.d.shortcuts"),
  require("conf.d.state"),      -- window geometry / splitter state (auto-saved)
}

for _, mod in ipairs(modules) do
  merge(settings, mod)
end
