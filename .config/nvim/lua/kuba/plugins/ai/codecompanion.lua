return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "zbirenbaum/copilot.lua",
    "nvim-telescope/telescope.nvim",
    "stevearc/dressing.nvim",
    "MeanderingProgrammer/render-markdown.nvim",
  },
  config = function()
    require("codecompanion").setup({
      mcp = {
        servers = {
          ["sequential-thinking"] = {
            cmd = { "npx", "-y", "@modelcontextprotocol/server-sequential-thinking" },
          },
          ["obsidian"] = {
            cmd = { "npx", "-y", "@bitbonsai/mcpvault@latest", "/home/kuba41/obsidian_vault" },
          },
        },
      },
      prompt_library = {
        markdown = {
          dirs = {
            vim.fn.stdpath("config") .. "/lua/kuba/plugins/ai/prompts",
          },
        },
      },
      interactions = {
        chat = {
          adapter = { name = "copilot", model = "claude-sonnet-4.6" },
          tools = {
            ["web_search"] = {
              opts = {
                adapter = "tavily",
              },
            },
          },
        },
        inline = { adapter = { name = "copilot", model = "claude-sonnet-4.6" } },
        agent = { adapter = { name = "copilot", model = "claude-sonnet-4.6" } },
      },
      opts = {
        log_level = "ERROR",
      },
      display = {
        chat = {
          window = {
            layout = "vertical",
            position = "right",
            width = 0.3,
          },
        },
        show_token_count = true,
      },
    })
  end,

  keys = {
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
  },
}
