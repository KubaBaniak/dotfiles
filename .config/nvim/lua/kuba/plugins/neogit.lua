return {
  "NeogitOrg/neogit",
  lazy = true,
  cmd = "Neogit",
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim", -- REQUIRED
    "sindrets/diffview.nvim", -- Diff integration
    "nvim-telescope/telescope.nvim", -- Picker integration
  },
  config = function()
    require("neogit").setup({
      graph_style = "unicode",

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "DiffviewFiles",
        callback = function()
          vim.opt_local.fixendofline = false
        end,
      }),

      -- Enable integrations explicitly
      integrations = {
        diffview = true,
        telescope = true,
      },
    })
  end,
}
