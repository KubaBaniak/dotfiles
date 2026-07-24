local constants = require("kuba.plugins.ai.codecompanion.constants")
local utils = require("kuba.plugins.ai.codecompanion.workflows.skills")

-- Superpowers Debug Workflow: Systematic debugging → verification
return {
  ["Superpowers Debug Workflow"] = {
interaction = "chat",
    description = "Systematyczne debugowanie → weryfikacja",
    opts = {
      index = 22,
      is_default = false,
      is_workflow = true,
      alias = "sp_debug", -- run with :CodeCompanion /sp_debug
      intro_message = "Superpowers Debug Workflow: opisz buga pod promptem i wyślij (<CR> w trybie normalnym).",
    },
    -- Agent tools so the LLM can read code, edit files and run tests while debugging
    tools = { "agent" },
    -- Default MCP servers (structured reasoning + knowledge graph memory)
    mcp_servers = { "sequential-thinking", "memory" },
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
              .. "\n\n---\n👇 **OPIS BUGA** (wpisz objawy, kroki reprodukcji i oczekiwane zachowanie poniżej tej linii, potem wyślij):\n\n"
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
