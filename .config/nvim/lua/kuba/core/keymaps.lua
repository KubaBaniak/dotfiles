local map = vim.keymap.set

-----------------------------------------------------------------------------
-- General
-----------------------------------------------------------------------------
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic location list" })

-----------------------------------------------------------------------------
-- Movement (keep the cursor centred)
-----------------------------------------------------------------------------
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "n", "nzzzv", { desc = "Next search result and center" })
map("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- Join lines without moving the cursor to the join point.
map("n", "J", "mzJ`z", { desc = "Join lines (keep cursor)" })

-----------------------------------------------------------------------------
-- Visual mode
-----------------------------------------------------------------------------
map("x", "<", "<gv", { desc = "Indent left and reselect" })
map("x", ">", ">gv", { desc = "Indent right and reselect" })
map("x", "J", ":move '>+1<CR>gv=gv", { desc = "Move selection down" })
map("x", "K", ":move '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Paste over a selection without clobbering the unnamed register.
map("x", "<leader>P", '"_dP', { desc = "Paste without yanking selection" })

-----------------------------------------------------------------------------
-- Registers
-----------------------------------------------------------------------------
-- Single-char delete should not clobber the unnamed register.
map({ "n", "x" }, "x", '"_x', { desc = "Delete char without yanking" })
