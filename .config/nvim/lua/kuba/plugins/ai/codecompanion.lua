return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "zbirenbaum/copilot.lua",
    "nvim-telescope/telescope.nvim",
    "stevearc/dressing.nvim",
    "MeanderingProgrammer/render-markdown.nvim",
    "nvim-mini/mini.diff",
    "ravitemer/mcphub.nvim",
  },
  config = function()
    require("codecompanion").setup({
      prompt_library = {
        markdown = {
          dirs = {
            vim.fn.stdpath("config") .. "/lua/kuba/plugins/ai/prompts",
          },
        },
      },
      strategies = {
        chat = { adapter = { name = "copilot", model = "claude-sonnet-4.6" } },
        inline = { adapter = { name = "copilot", model = "claude-sonnet-4.6" } },
        agent = { adapter = { name = "copilot", model = "claude-sonnet-4.6" } },
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            -- MCP Tools
            make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
            show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
            add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
            show_result_in_chat = true, -- Show tool results directly in chat buffer
            format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
            -- MCP Resources
            make_vars = false, -- Convert MCP resources to #variables for prompts
            -- MCP Prompts
            make_slash_commands = true, -- Add MCP prompts as /slash commands
          },
        },
      },
      opts = {
        log_level = "ERROR",
      },
      interactions = {
        chat = {
          tools = {
            ["web_search"] = {
              opts = {
                adapter = "tavily",
              },
            },
          },
        },
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
        diff = {
          provider = "mini_diff",
        },
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
