-- Replaces the archived stevearc/dressing.nvim.
-- `vim.ui.input`  -> snacks.input
-- `vim.ui.select` -> telescope-ui-select (see telescope.lua dependencies)
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- Disables syntax/treesitter/LSP for very large files so they open instantly.
    bigfile = { enabled = true },

    -- Renders the file before plugins load, so opening a file feels instant.
    quickfile = { enabled = true },

    -- Pretty replacement for the built-in `vim.ui.input` prompt.
    input = { enabled = true },

    -- Replaces the blocking `:messages` style notifications.
    notifier = {
      enabled = true,
      timeout = 3000,
      style = "compact",
    },

    -- Highlight/navigate references of the word under the cursor.
    words = { enabled = true },

    -- Show indent guides + current scope.
    indent = { enabled = true },

    -- kulala.nvim's picker config references snacks.picker; enabling it here
    -- makes that previously-dead code path actually work.
    -- ui_select also replaces dressing.nvim's vim.ui.select override.
    picker = { enabled = true, ui_select = true },
  },
  keys = {
    {
      "<leader>un",
      function()
        require("snacks").notifier.hide()
      end,
      desc = "Dismiss notifications",
    },
    {
      "<leader>pn",
      function()
        require("snacks").notifier.show_history()
      end,
      desc = "Notification history",
    },
    {
      "]]",
      function()
        require("snacks").words.jump(vim.v.count1)
      end,
      mode = { "n", "t" },
      desc = "Next reference",
    },
    {
      "[[",
      function()
        require("snacks").words.jump(-vim.v.count1)
      end,
      mode = { "n", "t" },
      desc = "Prev reference",
    },
  },
}
