-- Project rule files that get injected into chats as context.
--
-- The built-in `default` preset already auto-detects the common ones
-- (AGENT.md, AGENTS.md, CLAUDE.md, .cursorrules, .clinerules,
-- .github/copilot-instructions.md, ...). Missing files are simply skipped.
--
-- We add a `project` group for a couple of extra filenames, and — crucially —
-- enable `autoload_groups_in_prompt_library` so the prompt-library skills
-- (/review, /implement, /grill, ...) load these rules too, not just plain chats.
return {
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
      autoload = { "default", "project" },
      -- ...including chats started from the prompt library (the skills).
      autoload_groups_in_prompt_library = true,
    },
  },
}
