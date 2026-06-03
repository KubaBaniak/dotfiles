local constants = require("kuba.plugins.ai.codecompanion.constants")

return {
  http = {
    copilot = function()
      return require("codecompanion.adapters").extend("copilot", {
        schema = {
          model = {
            default = constants.DEFAULT_MODEL,
          },
          top_p = {
            enabled = function()
              return false
            end,
          },
        },
      })
    end,
  },
}
