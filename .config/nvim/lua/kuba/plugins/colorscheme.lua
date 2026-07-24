-- Inactive alternatives
-- local cyberdream = {
--   "scottmckendry/cyberdream.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme("cyberdream")
--   end,
-- }

-- local oxocarbon = {
--   "nyoom-engineering/oxocarbon.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme("oxocarbon")
--   end,
-- }

-- local zenbones = {
--   "mcchrish/zenbones.nvim",
--   dependencies = "rktjmp/lush.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.opt.background = "dark"
--     vim.cmd.colorscheme("zenbones")
--   end,
-- }

-- local moonfly = {
--   "bluz71/vim-moonfly-colors",
--   name = "moonfly",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme("moonfly")
--   end,
-- }

-- local kanagawa = {
--   "rebelot/kanagawa.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme("kanagawa-dragon")
--   end,
-- }

local catppuccin = {
  "catppuccin/nvim",
  name = "catppuccin-nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = false,
      auto_integrations = true,
    })

    vim.cmd.colorscheme("catppuccin-nvim")
  end,
}

local active = catppuccin
return active
