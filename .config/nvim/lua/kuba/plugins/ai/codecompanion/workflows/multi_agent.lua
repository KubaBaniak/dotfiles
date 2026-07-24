local constants = require("kuba.plugins.ai.codecompanion.constants")

local RESEARCHER_MODEL = constants.DEFAULT_MODEL -- deep context-gathering
local ORCHESTRATOR_MODEL = constants.DEFAULT_MODEL -- turns research into a plan
local WORKER_MODEL = constants.DEFAULT_MODEL -- executes the plan with tools

---Has the LLM produced a message containing the given marker yet?
---@param chat table CodeCompanion.Chat
---@param marker string
---@return boolean
local function llm_said(chat, marker)
  for i = #chat.messages, 1, -1 do
    local msg = chat.messages[i]
    if msg.role == "llm" and type(msg.content) == "string" and msg.content:find(marker, 1, true) then
      return true
    end
  end
  return false
end

return {
  ["Multi-Agent Workflow"] = {
    interaction = "chat",
    description = "Researcher → Orchestrator → Worker across three specialised models",
    opts = {
      index = 20,
      is_default = false,
      is_workflow = true,
      alias = "maw", -- run with :CodeCompanion /maw
      -- NOTE: intro_message is ignored for workflows (not passed to chat.new in Interactions:workflow())
    },
    -- "agent" is a built-in tool group (config.interactions.chat.tools.groups) containing:
    -- ask_questions, create_file, delete_file, file_search, get_changed_files,
    -- get_diagnostics, grep_search, insert_edit_into_file, read_file, run_command
    tools = { "agent" },
    -- NOTE: when mcp_servers is set explicitly, default_servers are NOT auto-started
    -- (see start_mcp_for_chat in chat/init.lua), so defaults must be listed here too.
    mcp_servers = { "sequential-thinking", "memory", "context7" },
    prompts = {
      {
        {
          role = "system",
          content = "You are part of a strict three-phase pipeline (Researcher → Orchestrator → "
            .. "Worker). Execute ONLY the phase given in the current turn. Never jump ahead to a "
            .. "later phase until its prompt arrives.",
          opts = { visible = false },
        },
        {
          name = "Researcher",
          role = "user",
          opts = {
            auto_submit = false,
            adapter = constants.copilot_adapter(RESEARCHER_MODEL),
          },
          content = function()
            return [[
You are the **Researcher** in a three-agent pipeline.

Your job is to gather all the context needed to solve the task described below (under this prompt).
Do NOT write code yet. Do NOT suggest solutions yet.

Instead:
1. Read the task description the user has provided below this prompt.
2. Use available tools (@{read_file}, @{file_search}, @{grep_search} etc.) to explore the codebase.
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
          -- Wait until the Researcher has actually finished (tool loops, clarifying
          -- questions etc. also count as response cycles, so we gate on the marker)
          condition = function(chat)
            return llm_said(chat, "## Research Summary")
          end,
          content = [[
You are the **Orchestrator** in a three-agent pipeline.

The Researcher above has produced a Research Summary. Your job is to turn that into a
precise, numbered implementation plan that the Worker can execute mechanically.

Rules:
- Do NOT write any code yourself.
- Each step must be atomic and unambiguous (one file, one concern per step).
- Reference file paths exactly as the Researcher identified them.
- Flag any assumptions explicitly.
- End with a section clearly labelled:
## Execution Plan
(paste your numbered plan here)
]],
        },
      },

      {
        {
          name = "Worker",
          role = "user",
          opts = {
            auto_submit = true,
            adapter = constants.copilot_adapter(WORKER_MODEL),
          },
          -- Wait until the Orchestrator has produced its plan
          condition = function(chat)
            return llm_said(chat, "## Execution Plan")
          end,
          content = [[
You are the **Worker** in a three-agent pipeline.

The Orchestrator has produced an Execution Plan above. Your job is to implement it
exactly, step by step, using the available tools.

Rules:
- Follow the Execution Plan in order. Do not skip or reorder steps.
- Use @{insert_edit_into_file} to write or modify files.
- Use @{run_command} to verify your changes (run tests, linters, etc.).
- IMPORTANT: whenever you run the test suite with @{run_command}, set its `flag`
  parameter to "testing" so the result is tracked by the workflow.
- After all steps are done, produce a short completion report:
  - What was done
  - Any deviations from the plan and why
  - Suggested follow-up tasks if any
]],
        },
      },

      -- ── Phase 4: Verification loop ──────────────────────────────────────
      {
        {
          name = "Repeat On Failure",
          role = "user",
          opts = {
            auto_submit = true,
            adapter = constants.copilot_adapter(WORKER_MODEL),
          },
          -- Only fires when the run_command tool was just used
          condition = function(chat)
            return chat.tools.tool and chat.tools.tool.name == "run_command"
          end,
          -- Keep re-prompting until run_command reports a passing test suite
          -- (run_command sets chat.tool_registry.flags.testing = exit_code == 0)
          repeat_until = function(chat)
            return (chat.tool_registry.flags or {}).testing == true
          end,
          content = 'The tests have failed. Review the output above, fix the code with the @{insert_edit_into_file} tool, and run the test suite again with the @{run_command} tool (remember to set `flag` to "testing").',
        },
      },
    },
  },
}
