return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-ui-select.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")

    telescope.setup({
      defaults = {
        file_ignore_patterns = { "%.git/" },
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_config = {
          prompt_position = "top",
        },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<Esc>"] = actions.close,
          },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")

    -- File finders
    vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Search Git Files" })
    vim.keymap.set("n", "<leader>pf", function()
      builtin.find_files({ hidden = true })
    end, { desc = "Search All Files" })
    vim.keymap.set("n", "<leader>ps", builtin.live_grep, { desc = "Live Grep" })
    vim.keymap.set("n", "<leader>pb", builtin.buffers, { desc = "Search Open Buffers" })

    -- Additional keymaps
    vim.keymap.set("n", "<leader>pw", builtin.grep_string, { desc = "Grep Word Under Cursor" })
    vim.keymap.set("n", "<leader>pr", builtin.oldfiles, { desc = "Recent Files" })
    vim.keymap.set("n", "<leader>pd", builtin.diagnostics, { desc = "Search Diagnostics" })
    vim.keymap.set("n", "<leader>ph", builtin.help_tags, { desc = "Search Help Tags" })
  end,
}
