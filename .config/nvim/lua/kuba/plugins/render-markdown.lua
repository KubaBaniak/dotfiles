return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  ft = { "markdown", "codecompanion", "kulala_ui" },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    latex = {
      enabled = true,
      converter = { "latex2text", "utftex" },
      inline = true,
      block = true,
      position = "center", -- 'center', 'above', or 'below'
    },
    completions = {
      lsp = { enable = true, priority = 10 },
      treesitter = { enable = true, priority = 5 },
    },
  },
}
