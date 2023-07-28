vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]

