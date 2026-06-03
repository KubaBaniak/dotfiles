return {
  { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Toggle Chat" },
  { "<leader>cx", ":CodeCompanion /", mode = { "n", "v" }, desc = "CodeCompanion slash command" },
  { "<leader>cp", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Actions Menu" },
  { "<leader>cq", "<cmd>CodeCompanion<cr>", mode = "n", desc = "CodeCompanion: Quick Inline Prompt" },
  { "<leader>ce", "<cmd>CodeCompanion /explain<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Explain code" },
  { "<leader>cf", "<cmd>CodeCompanion /fix<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Fix code" },
  { "<leader>co", "<cmd>CodeCompanion /optimize<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Optimize code" },
  { "<leader>ct", "<cmd>CodeCompanion /tests<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Generate tests" },
  { "<leader>cr", "<cmd>CodeCompanion /refactor<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Refactor code" },
  { "<leader>cv", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "CodeCompanion: Add selection to chat" },
}
