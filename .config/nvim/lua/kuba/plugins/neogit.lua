return {
  "NeogitOrg/neogit",
  lazy = true,
  cmd = "Neogit",
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "DiffviewFiles",
      callback = function()
        vim.opt_local.fixendofline = false
      end,
    })

    require("neogit").setup({
      graph_style = "unicode",
      integrations = {
        diffview = true,
        telescope = true,
      },
    })
  end,
}
