local catppuccin = {
  "catppuccin/nvim",
  name = "catppuccin-nvim",
  priority = 1000,
  config = function()
    vim.opt.termguicolors = true

    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = false,
      -- `default_integrations = true` (the default) already enables these for
      -- plugins you use: blink_cmp, flash, gitsigns, neogit,
      -- neotree, render_markdown, telescope, treesitter (native), + more.
      -- Below are the integrations for plugins you have that are OFF by default.
      integrations = {
        gitgraph = true, -- isakbm/gitgraph.nvim
        harpoon = true, -- ThePrimeagen/harpoon
        lsp_trouble = true, -- folke/trouble.nvim
        mason = true, -- mason-org/mason(-lspconfig).nvim
        nvim_surround = true, -- kylechui/nvim-surround
        which_key = true, -- folke/which-key.nvim
        window_picker = true, -- s1n7ax/nvim-window-picker
      },
      -- Tip (lazy.nvim users): you could replace the table above with
      -- `auto_integrations = true` to auto-detect installed plugins instead.
    })

    vim.cmd.colorscheme("catppuccin-nvim")
  end,
}

local cyberdream = {
  "scottmckendry/cyberdream.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("cyberdream")
  end,
}

local oxocarbon = {
  "nyoom-engineering/oxocarbon.nvim",
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("oxocarbon")
  end,
}

local zenbones = {
  "mcchrish/zenbones.nvim",
  dependencies = "rktjmp/lush.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.opt.termguicolors = true
    vim.opt.background = "dark" -- or "light"
    vim.cmd.colorscheme("zenbones")
  end,
}

local moonfly = {
  "bluz71/vim-moonfly-colors",
  name = "moonfly",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("moonfly")
  end,
}

local kanagawa = {
  "rebelot/kanagawa.nvim",
  config = function()
    vim.cmd.colorscheme("kanagawa-dragon")
  end,
}

return catppuccin
