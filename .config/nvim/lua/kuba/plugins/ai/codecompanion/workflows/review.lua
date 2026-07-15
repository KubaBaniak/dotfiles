local constants = require("kuba.plugins.ai.codecompanion.constants")
local utils = require("kuba.plugins.ai.codecompanion.workflows.skills")

-- Superpowers Review Workflow: Code review → finalise branch
return {
  ["Superpowers Review Workflow"] = {
    strategy = "workflow",
    description = "Code review → finalizacja brancha",
    opts = {
      index = 23,
      is_default = false,
      short_name = "sp_review",
    },
    prompts = {
      {
        {
          name = "Review",
          role = "user",
          opts = {
            auto_submit = false,
            adapter = constants.copilot_adapter(),
          },
          content = function()
            return utils.code_review()
          end,
        },
      },
      {
        {
          name = "Finish",
          role = "user",
          opts = {
            auto_submit = true,
            adapter = constants.copilot_adapter(),
          },
          content = function()
            return utils.finishing()
          end,
        },
      },
    },
  },
}
