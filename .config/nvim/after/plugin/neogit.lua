local neogit = require("neogit")
neogit.setup({})
vim.api.nvim_set_keymap("n", "<Leader>g", [[:Neogit kind=vsplit<CR>]], { noremap = true, silent = true })
