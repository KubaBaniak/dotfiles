local constants = require("kuba.plugins.ai.codecompanion.constants")

return {
  chat = {
    adapter = constants.copilot_adapter(),
    opts = {
      system_prompt = require("kuba.plugins.ai.codecompanion.system_prompt"),
    },
    tools = require("kuba.plugins.ai.codecompanion.tools"),
  },
  inline = {
    adapter = constants.copilot_adapter(),
  },
  agent = {
    adapter = constants.copilot_adapter(),
  },
}
