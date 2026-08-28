local constants = require("kuba.plugins.ai.codecompanion.constants")
local secret = require("kuba.secrets")

return {
  http = {
    deepseek = function()
      return require("codecompanion.adapters").extend("deepseek", {
        env = {
          api_key = function()
            return secret("DEEPSEEK_API_KEY")
          end,
        },
      })
    end,
    copilot = function()
      return require("codecompanion.adapters").extend("copilot", {
        schema = {
          model = {
            default = constants.DEFAULT_MODEL,
          },
        },
      })
    end,
  },
}
