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
    require("neogit").setup({
      disable_insert_on_commit = "auto",
      process_spinner = true,
      prompt_force_push = true,
      prompt_amend_commit = true,
      graph_style = "kitty",
      kind = "tab",
      commit_editor = {
        kind = "tab",
        show_staged_diff = true,
        staged_diff_split_kind = "auto",
        spell_check = true,
      },
      remember_settings = true,
      use_per_project_settings = true,
      sections = {
        stashes = { folded = true, hidden = false },
        unpulled_upstream = { folded = true, hidden = false },
        recent = { folded = true, hidden = false },
      },
      integrations = {
        diffview = true,
        telescope = true,
      },
    })
  end,
}
