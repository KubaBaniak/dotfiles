local constants = require("kuba.plugins.ai.codecompanion.constants")

return {
  -- Later directories win, so personal and project skills can override upstream.
  dirs = {
    constants.SUPERPOWERS_SKILLS_DIR,
    "~/.config/codecompanion/skills",
    "~/.agents/skills",
    "~/.claude/skills",
    ".codecompanion/skills",
    ".claude/skills",
    ".agents/skills",
  },
  opts = {
    chat = {
      -- Advertise skills, not their full bodies. Read SKILL.md on invocation.
      -- Upstream uses one directory per skill, named after its frontmatter name.
      autoload = function()
        local names = {}
        for _, path in ipairs(vim.fn.glob(constants.SUPERPOWERS_SKILLS_DIR .. "/*/SKILL.md", false, true)) do
          names[#names + 1] = vim.fs.basename(vim.fs.dirname(path))
        end
        table.sort(names)
        return names
      end,
    },
  },
}
