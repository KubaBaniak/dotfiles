return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    -- REQUIRED
    vim.opt.termguicolors = true

    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = false,
    })

    vim.cmd.colorscheme("catppuccin")
  end,
}
