return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter")

    configs.setup({
      ensure_installed = { "c", "lua", "vim", "vimdoc", "typescript", "javascript", "tsx", "html", "yaml" },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
