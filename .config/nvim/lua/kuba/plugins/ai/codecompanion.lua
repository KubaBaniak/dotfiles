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
  opts = function()
    return require("kuba.plugins.ai.codecompanion.opts")
  end,
  config = function(_, opts)
    require("codecompanion").setup(opts)
  end,
  keys = require("kuba.plugins.ai.codecompanion.keys"),
}
