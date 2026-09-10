local constants = require("kuba.plugins.ai.codecompanion.constants")

-- Project rule files and methodology that get injected into chats as context.
--
-- The built-in `default` preset already auto-detects common project files
-- (AGENT.md, AGENTS.md, CLAUDE.md, .cursorrules, .clinerules,
-- .github/copilot-instructions.md, ...). Missing files are simply skipped.
--
-- `superpowers` loads the development methodology bootstrap and skill catalog.
-- `superpowers-skills` provides sub-groups for individual skills in the picker.
return {
  superpowers = {
    description = "Superpowers development methodology and bootstrap",
    parser = "codecompanion",
    files = {
      constants.SUPERPOWERS_RULES,
    },
  },
  ["superpowers-skills"] = {
    description = "Superpowers individual skills",
    files = {
      ["brainstorming"] = {
        description = "Socratic design refinement before writing code",
        files = { constants.SUPERPOWERS_SKILLS_DIR .. "/brainstorming/SKILL.md" },
      },
      ["writing-plans"] = {
        description = "Break work into bite-sized tasks",
        files = { constants.SUPERPOWERS_SKILLS_DIR .. "/writing-plans/SKILL.md" },
      },
      ["executing-plans"] = {
        description = "Batch execution with checkpoints",
        files = { constants.SUPERPOWERS_SKILLS_DIR .. "/executing-plans/SKILL.md" },
      },
      ["tdd"] = {
        description = "RED-GREEN-REFACTOR cycle",
        files = { constants.SUPERPOWERS_SKILLS_DIR .. "/test-driven-development/SKILL.md" },
      },
      ["systematic-debugging"] = {
        description = "4-phase root cause process",
        files = { constants.SUPERPOWERS_SKILLS_DIR .. "/systematic-debugging/SKILL.md" },
      },
      ["verification"] = {
        description = "Verify before completion",
        files = { constants.SUPERPOWERS_SKILLS_DIR .. "/verification-before-completion/SKILL.md" },
      },
      ["requesting-review"] = {
        description = "Pre-review checklist",
        files = { constants.SUPERPOWERS_SKILLS_DIR .. "/requesting-code-review/SKILL.md" },
      },
      ["receiving-review"] = {
        description = "Responding to code review",
        files = { constants.SUPERPOWERS_SKILLS_DIR .. "/receiving-code-review/SKILL.md" },
      },
      ["git-worktrees"] = {
        description = "Parallel development branches",
        files = { constants.SUPERPOWERS_SKILLS_DIR .. "/using-git-worktrees/SKILL.md" },
      },
      ["finishing-branch"] = {
        description = "Merge/PR decision workflow",
        files = { constants.SUPERPOWERS_SKILLS_DIR .. "/finishing-a-development-branch/SKILL.md" },
      },
      ["subagent-dev"] = {
        description = "Subagent-driven development",
        files = { constants.SUPERPOWERS_SKILLS_DIR .. "/subagent-driven-development/SKILL.md" },
      },
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
      autoload = { "default", "superpowers", "project" },
      -- ...including chats started from the prompt library (the skills).
      autoload_groups_in_prompt_library = true,
    },
  },
}
