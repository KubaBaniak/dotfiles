return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",  -- required
    "sindrets/diffview.nvim", -- optional - Diff integration

    -- Only one of these is needed, not both.
    "nvim-telescope/telescope.nvim", -- optional
    --"ibhagwan/fzf-lua",              -- optional
  },

    vim.api.nvim_set_keymap("n", "<Leader>g", [[:Neogit kind=vsplit<CR>]], { noremap = true, silent = true })
}
