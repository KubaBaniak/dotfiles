local constants = require("kuba.plugins.ai.codecompanion.constants")
local utils = require("kuba.plugins.ai.codecompanion.workflows.skills")

-- Superpowers Review Workflow: Code review → finalise branch
return {
  ["Superpowers Review Workflow"] = {
interaction = "chat",
    description = "Code review → finalizacja brancha",
    opts = {
      index = 23,
      is_default = false,
      is_workflow = true,
      alias = "sp_review", -- run with :CodeCompanion /sp_review
      intro_message = "Superpowers Review Workflow: opcjonalnie doprecyzuj zakres review pod promptem i wyślij (<CR> w trybie normalnym).",
    },
    -- Agent tools so the LLM can inspect the diff, files and run checks
    tools = { "agent" },
    -- Default MCP servers (structured reasoning + knowledge graph memory)
    mcp_servers = { "sequential-thinking", "memory" },
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
              .. "\n\n---\n👇 **ZAKRES REVIEW** (opcjonalnie: wpisz branch/commit lub obszar do sprawdzenia poniżej, potem wyślij):\n\n"
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
