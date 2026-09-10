local M = {}

M.DEFAULT_MODEL = "gemini-3.8-flash"
M.PROMPTS_DIR = vim.fn.stdpath("config") .. "/lua/kuba/plugins/ai/prompts"
M.KARPATHY_GUIDELINES = vim.fn.stdpath("config") .. "/lua/kuba/plugins/ai/skills/karpathy-guidelines.md"
M.SUPERPOWERS_DIR = vim.fn.stdpath("config") .. "/skills/superpowers"
M.SUPERPOWERS_SKILLS_DIR = M.SUPERPOWERS_DIR .. "/skills"
M.SUPERPOWERS_RULES = vim.fn.stdpath("config") .. "/lua/kuba/plugins/ai/skills/superpowers.md"
M.OBSIDIAN_VAULT = "/home/kuba41/obsidian_vault"

function M.copilot_adapter(model)
  return { name = "copilot", model = model or M.DEFAULT_MODEL }
end

return M
