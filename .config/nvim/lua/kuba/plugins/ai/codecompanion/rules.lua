local constants = require("kuba.plugins.ai.codecompanion.constants")

-- Project rule files and methodology that get injected into chats as context.
--
-- The built-in `default` preset already auto-detects common project files
-- (AGENT.md, AGENTS.md, CLAUDE.md, .cursorrules, .clinerules,
-- .github/copilot-instructions.md, ...). Missing files are simply skipped.
--
-- `superpowers` loads the upstream bootstrap and local tool mapping.
-- `tool_use` keeps general tool-selection guidance separate from Superpowers.
-- Individual skills are discovered and advertised by skills.lua (/skills picker).
return {
  superpowers = {
    description = "Superpowers development methodology and bootstrap",
    parser = "codecompanion",
    files = {
      constants.SUPERPOWERS_RULES,
    },
  },
  tool_use = {
    description = "General tool-selection guidance",
    parser = "codecompanion",
    files = {
      vim.fn.stdpath("config") .. "/lua/kuba/plugins/ai/rules/tool-use.md",
    },
  },
  project = {
    description = "Extra project-level rule files",
    files = {
      "SKILLS.md",
      "docs/AGENTS.md",
    },
  },
  opts = {
    chat = {
      -- Load these rule groups into every chat...
      autoload = { "default", "superpowers", "tool_use", "project" },
      -- ...including chats started from the prompt library (the skills).
      autoload_groups_in_prompt_library = true,
    },
  },
}
