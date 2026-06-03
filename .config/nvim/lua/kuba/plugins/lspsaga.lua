return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    ui = {
      border = "rounded",
      devicon = true,
      -- use the same title colour as your theme
      title = true,
    },
    hover = {
      max_width = 0.7,
      max_height = 0.4,
      open_link = "gx",   -- open URLs inside hover with gx
      open_cmd = "!xdg-open",
    },
    definition = {
      width = 0.6,
      height = 0.4,
    },
    lightbulb = {
      enable = false, -- turn on if you want a 💡 sign for code actions
    },
    symbol_in_winbar = {
      enable = false, -- breadcrumbs in winbar; enable if you want it
    },
  },
}
