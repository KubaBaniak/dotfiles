local constants = require("kuba.plugins.ai.codecompanion.constants")

return {
  dirs = {
    "~/.config/codecompanion/skills",
    ".codecompanion/skills",
    "~/.claude/skills",
    ".claude/skills",
    constants.SUPERPOWERS_SKILLS_DIR,
    ".agents/skills",
  },
}
