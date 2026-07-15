local constants = require("kuba.plugins.ai.codecompanion.constants")
local utils = require("kuba.plugins.ai.codecompanion.workflows.skills")

-- Superpowers Debug Workflow: Systematic debugging → verification
return {
  ["Superpowers Debug Workflow"] = {
    strategy = "workflow",
    description = "Systematyczne debugowanie → weryfikacja",
    opts = {
      index = 22,
      is_default = false,
      short_name = "sp_debug",
    },
    prompts = {
      {
        {
          name = "Debug",
          role = "user",
          opts = {
            auto_submit = false,
            adapter = constants.copilot_adapter(),
          },
          content = function()
            return utils.debugging()
          end,
        },
      },
      {
        {
          name = "Verify",
          role = "user",
          opts = {
            auto_submit = true,
            adapter = constants.copilot_adapter(),
          },
          content = function()
            return utils.verification()
          end,
        },
      },
    },
  },
}
