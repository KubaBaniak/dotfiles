local constants = require("kuba.plugins.ai.codecompanion.constants")
local utils = require("kuba.plugins.ai.codecompanion.workflows.skills")

-- Superpowers Feature Workflow: Brainstorm → Plan → TDD → Verify
-- Each phase runs as its own turn-based step. The first three steps pause so you
-- can review/refine before submitting; the final verification auto-submits.
-- To run a phase on a different model, pass a model to constants.copilot_adapter().
return {
  ["Superpowers Feature Workflow"] = {
interaction = "chat",
    description = "Brainstorm → plan → TDD → weryfikacja",
    opts = {
      index = 21,
      is_default = false,
      is_workflow = true,
      alias = "sp_feature", -- run with :CodeCompanion /sp_feature
      intro_message = "Superpowers Feature Workflow: opisz feature pod promptem fazy 1 i wyślij (<CR> w trybie normalnym). Kolejne fazy zatwierdzasz ręcznie.",
    },
    -- Full agent tool group so TDD/verify phases can edit files and run tests
    tools = { "agent" },
    -- MCP servers to auto-start with this workflow (defaults + context7 for docs lookup)
    mcp_servers = { "sequential-thinking", "memory", "context7" },
    prompts = {
      {
        {
          role = "system",
          content = "You follow a strict 4-phase workflow. Execute ONLY the phase provided in each turn. "
            .. "Do not jump ahead to later phases until instructed.",
          opts = { visible = false },
        },
      },
      -- Phase 1 — Brainstorm
      {
        {
          name = "Brainstorm",
          role = "user",
          opts = {
            auto_submit = false,
            adapter = constants.copilot_adapter(),
          },
          content = function()
            return "Faza 1 (Brainstorm): Zbadaj kontekst projektu i zapytaj mnie o zadanie.\n\n"
              .. utils.brainstorming()
              .. "\n\n---\n👇 **MOJE ZADANIE** (wpisz opis feature'a poniżej tej linii i wyślij wiadomość):\n\n"
          end,
        },
      },
      -- Phase 2 — Plan
      {
        {
          name = "Plan",
          role = "user",
          opts = {
            auto_submit = false,
            adapter = constants.copilot_adapter(),
          },
          content = function()
            return "Faza 2 (Plan):\n\n" .. utils.writing_plans()
          end,
        },
      },
      -- Phase 3 — Implement (TDD)
      {
        {
          name = "Implement",
          role = "user",
          opts = {
            auto_submit = false,
            adapter = constants.copilot_adapter(),
          },
          content = function()
            return "Faza 3 (Implement, TDD):\n\n" .. utils.tdd()
          end,
        },
      },
      -- Phase 4 — Verify
      {
        {
          name = "Verify",
          role = "user",
          opts = {
            auto_submit = true,
            adapter = constants.copilot_adapter(),
          },
          content = function()
            return "Faza 4 (Verify):\n\n" .. utils.verification()
          end,
        },
      },
    },
  },
}
