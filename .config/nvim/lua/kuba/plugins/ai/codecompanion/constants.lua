local M = {}

M.DEFAULT_MODEL = "claude-sonnet-4.6"
M.PROMPTS_DIR = vim.fn.stdpath("config") .. "/lua/kuba/plugins/ai/prompts"
M.KARPATHY_GUIDELINES = vim.fn.stdpath("config") .. "/lua/kuba/plugins/ai/skills/karpathy-guidelines.md"
M.OBSIDIAN_VAULT = "/home/kuba41/obsidian_vault"

function M.copilot_adapter()
  return { name = "copilot", model = M.DEFAULT_MODEL }
end

return M
