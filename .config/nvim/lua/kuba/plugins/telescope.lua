return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    --"debugloop/telescope-undo.nvim",
  },
  config = function()
    require("telescope").setup({
      defaults = {
        file_ignore_patterns = {
          "metadata",
          "node_modules",
          "dist"
        }
      }
    })
    --require("telescope").load_extension("undo")
    --vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
    vim.keymap.set('n', '<C-p>', builtin.git_files, {})
    vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})
  end,
}
