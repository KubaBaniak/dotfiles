local constants = require("kuba.plugins.ai.codecompanion.constants")

return {
  chat = {
    adapter = constants.copilot_adapter(),
    opts = {
      system_prompt = require("kuba.plugins.ai.codecompanion.system_prompt"),
      context_management = {
        compaction = {
          adapter = {
            name = "copilot",
            model = "gpt-5.6-luna",
          },
          fallback_to_chat_adapter = true,
        },
      },
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
