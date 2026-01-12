return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",

    -- 1. Konfiguracja wtyczki
    opts = {
      -- Model: Używamy 'gpt-4o' (standard dla Copilota)
      model = "gpt-4o",

      -- Zachowanie: Tryb insert po otwarciu
      auto_insert_mode = true,

      window = {
        layout = "float", -- To musi być 'float'
        relative = "editor", -- Pozycjonowanie względem całego edytora
        width = 0.6, -- 60% szerokości ekranu (ułamek dla float)
        height = 0.7, -- 70% wysokości ekranu
        border = "rounded", -- Zaokrąglona ramka wygląda lepiej we float
        title = "🤖 Copilot Float",
        row = nil, -- nil = wyśrodkowanie w pionie
        col = nil, -- nil = wyśrodkowanie w poziomie
      },

      headers = {
        user = "👤 You",
        assistant = "🤖 Copilot",
        tool = "🔧 Tool",
      },
    },

    -- 2. Klawisze (Musi być POZA 'opts', żeby działało w lazy.nvim)
    keys = {
      {
        "<leader>cc",
        "<cmd>CopilotChatToggle<cr>",
        desc = "Copilot Chat Toggle",
        mode = { "n", "v" }, -- Działa w trybie normalnym i visual
      },
      {
        "<leader>cx",
        "<cmd>CopilotChatReset<cr>",
        desc = "Copilot Chat Reset",
        mode = { "n", "v" },
      },
      {
        "<leader>cq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "Copilot Quick Chat",
        mode = { "n", "v" },
      },
    },
  },
}
