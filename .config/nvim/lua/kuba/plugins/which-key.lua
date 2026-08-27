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
      { "<leader>m", group = "Format/Lint" },
      { "<leader>n", group = "Explorer" },
      { "<leader>e", desc = "Jump to/from file explorer" },
      { "<leader>p", group = "Pick/Search" },
      { "<leader>r", group = "LSP Refactor" },
      { "<leader>s", group = "Search/Replace" },
      { "<leader>t", group = "Toggle" },
      { "<leader>u", group = "UI/Undo" },
      { "<leader>x", group = "Diagnostics/Lists" },
      { "<leader>w", proxy = "<C-w>", group = "Windows" },
      { "<leader>R", group = "REST" },
      -- Harpoon slots (replacing the dead <C-1>..<C-4> mappings)
      { "<leader>1", hidden = true },
      { "<leader>2", hidden = true },
      { "<leader>3", hidden = true },
      { "<leader>4", hidden = true },
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
