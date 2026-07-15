local constants = require("kuba.plugins.ai.codecompanion.constants")

local library = {
  markdown = {
    dirs = {
      constants.PROMPTS_DIR,
    },
  },
}

-- Merge in all Lua-defined workflows from the workflows/ directory
for name, spec in pairs(require("kuba.plugins.ai.codecompanion.workflows")) do
  library[name] = spec
end

return library
