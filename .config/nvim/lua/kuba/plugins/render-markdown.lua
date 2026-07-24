return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  ft = { "markdown", "codecompanion", "kulala_ui" },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    completions = {
      lsp = { enable = true, priority = 10 },
      treesitter = { enable = true, priority = 5 },
    },
  },
}
