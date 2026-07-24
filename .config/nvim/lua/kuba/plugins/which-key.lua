return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 200,
    spec = {
      { "<leader>c", group = "Code" },
      { "<leader>g", group = "Git" },
      { "<leader>h", group = "Harpoon" },
      { "<leader>m", group = "Modify" },
      { "<leader>n", group = "Explorer" },
      { "<leader>p", group = "Pick/Search" },
      { "<leader>r", group = "LSP" },
      { "<leader>s", group = "Search/Replace" },
      { "<leader>t", group = "Toggle" },
      { "<leader>x", group = "Diagnostics/Lists" },
      { "<leader>w", proxy = "<C-w>", group = "Windows" },
      { "<leader>R", group = "REST" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer-local keymaps",
    },
  },
}
