local constants = require("kuba.plugins.ai.codecompanion.constants")

-- ─────────────────────────────────────────────────────────────────────────────
-- Multi-Agent Workflow model assignments
-- Change these three strings to swap which model handles each role.
-- ─────────────────────────────────────────────────────────────────────────────
local RESEARCHER_MODEL = "claude-sonnet-4.6" -- deep context-gathering
local ORCHESTRATOR_MODEL = "claude-sonnet-4.6" -- TODO: change to your "Fable 5" model ID
local WORKER_MODEL = "claude-sonnet-4.6" -- TODO: change to your "Sonnet 5.0" model ID

-- Phase 1 → Researcher  : reads codebase, gathers context, surfaces facts
-- Phase 2 → Orchestrator: turns research into a concrete, numbered plan
-- Phase 3 → Worker      : executes the plan step-by-step with tools
return {
  ["Multi-Agent Workflow"] = {
    strategy = "workflow",
    description = "Researcher → Orchestrator → Worker across three specialised models",
    opts = {
      index = 20,
      is_default = false,
      short_name = "maw",
    },
    prompts = {
      -- ── Phase 1: Researcher ────────────────────────────────────────────────
      {
        {
          name = "Researcher",
          role = "user",
          opts = {
            auto_submit = false, -- pause so you can describe the task first
            adapter = constants.copilot_adapter(RESEARCHER_MODEL),
          },
          content = function()
            return [[
You are the **Researcher** in a three-agent pipeline.

Your job is to gather all the context needed to solve the task the user is about to describe.
Do NOT write code yet. Do NOT suggest solutions yet.

Instead:
1. Ask the user what task they want to accomplish.
2. Use available tools (@{read_file}, @{glob}, @{grep} etc.) to explore the codebase.
3. Summarise your findings in a structured report:
   - Relevant files and their roles
   - Existing patterns, conventions, and constraints
   - Potential risks or unknowns
   - Any open questions that need to be answered before implementation

End your report with a clearly labelled section:
## Research Summary
(paste your structured findings here)
]]
          end,
        },
      },

      -- ── Phase 2: Orchestrator ──────────────────────────────────────────────
      {
        {
          name = "Orchestrator",
          role = "user",
          opts = {
            auto_submit = true,
            adapter = constants.copilot_adapter(ORCHESTRATOR_MODEL),
          },
          content = [[
You are the **Orchestrator** in a three-agent pipeline.

The Researcher above has produced a Research Summary. Your job is to turn that into a
precise, numbered implementation plan that the Worker can execute mechanically.

Rules:
- Do NOT write any code yourself.
- Each step must be atomic and unambiguous (one file, one concern per step).
- Reference file paths exactly as the Researcher identified them.
- Flag any assumptions explicitly.
- End with a section labelled:

## Execution Plan
(numbered list of steps here)
]],
        },
      },

      -- ── Phase 3: Worker ────────────────────────────────────────────────────
      {
        {
          name = "Worker",
          role = "user",
          opts = {
            auto_submit = true,
            adapter = constants.copilot_adapter(WORKER_MODEL),
          },
          content = [[
You are the **Worker** in a three-agent pipeline.

The Orchestrator has produced an Execution Plan above. Your job is to implement it
exactly, step by step, using the available tools.

Rules:
- Follow the Execution Plan in order. Do not skip or reorder steps.
- Use @{insert_edit_into_file} to write or modify files.
- Use @{run_command} to verify your changes (run tests, linters, etc.).
- After all steps are done, produce a short completion report:
  - What was done
  - Any deviations from the plan and why
  - Suggested follow-up tasks if any
]],
        },
      },
    },
  },
}
