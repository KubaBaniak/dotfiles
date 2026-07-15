-- Aggregates all Lua-defined workflows into a single prompt_library table.
-- To add a new workflow: drop a `<name>.lua` file in this directory that returns
-- a table keyed by its display name, then add its module name below.
local modules = {
  "multi_agent",
  "feature",
  "debug",
  "review",
}

local M = {}
for _, mod in ipairs(modules) do
  local entries = require("kuba.plugins.ai.codecompanion.workflows." .. mod)
  for name, spec in pairs(entries) do
    M[name] = spec
  end
end

return M
