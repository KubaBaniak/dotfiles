return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    --"debugloop/telescope-undo.nvim",
  },
  config = function()
    require("telescope").setup({
      defaults = {
        file_ignore_patterns = {
          "metadata",
          "node_modules",
          "dist",
          "%.git/",
        },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },
    })
    require("telescope").load_extension("fzf")
    --require("telescope").load_extension("undo")
    --vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
    vim.keymap.set("n", "<C-p>", builtin.git_files, {})
    vim.keymap.set("n", "<leader>ps", builtin.live_grep, {})
  end,
}
