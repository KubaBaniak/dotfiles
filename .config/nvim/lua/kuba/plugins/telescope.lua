return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      -- Skip the extension entirely if `make` never produced the .so
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  -- Lazy-load on keypress rather than setting keymaps inside config().
  keys = {
    { "<C-p>", "<cmd>Telescope git_files<CR>", desc = "Search Git Files" },
    {
      "<leader>pf",
      function()
        require("telescope.builtin").find_files({ hidden = true })
      end,
      desc = "Search All Files",
    },
    { "<leader>ps", "<cmd>Telescope live_grep<CR>", desc = "Live Grep" },
    { "<leader>pb", "<cmd>Telescope buffers<CR>", desc = "Search Open Buffers" },
    { "<leader>pw", "<cmd>Telescope grep_string<CR>", desc = "Grep Word Under Cursor" },
    { "<leader>pr", "<cmd>Telescope oldfiles<CR>", desc = "Recent Files" },
    { "<leader>pd", "<cmd>Telescope diagnostics<CR>", desc = "Search Diagnostics" },
    { "<leader>ph", "<cmd>Telescope help_tags<CR>", desc = "Search Help Tags" },
    { "<leader>pk", "<cmd>Telescope keymaps<CR>", desc = "Search Keymaps" },
    { "<leader>pc", "<cmd>Telescope commands<CR>", desc = "Search Commands" },
    { "<leader>p/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search In Buffer" },
    { "<leader>p.", "<cmd>Telescope resume<CR>", desc = "Resume Last Picker" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        file_ignore_patterns = { "%.git/", "node_modules/", "%.next/", "dist/" },
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
            -- <Esc> closes instead of dropping to normal mode.
            ["<Esc>"] = actions.close,
            ["<C-u>"] = false, -- let <C-u> clear the prompt line
          },
          n = {
            ["q"] = actions.close,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
      pickers = {
        find_files = { hidden = true },
        buffers = {
          sort_lastused = true,
          mappings = {
            i = { ["<C-d>"] = actions.delete_buffer },
            n = { ["dd"] = actions.delete_buffer },
          },
        },
      },
      -- NOTE: vim.ui.select is handled by snacks.picker (ui_select = true),
      -- because Telescope is lazy-loaded and would not be available at startup.
    })

    pcall(telescope.load_extension, "fzf")
  end,
}
