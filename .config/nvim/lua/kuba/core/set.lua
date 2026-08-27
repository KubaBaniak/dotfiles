local o = vim.o

-----------------------------------------------------------------------------
-- UI
-----------------------------------------------------------------------------
o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = "yes"
o.scrolloff = 8
o.sidescrolloff = 8
o.termguicolors = true
o.guifont = "Iosevka Nerd Font"

-- 0.11+: global default border for all floating windows.
-- This makes per-plugin `border = "rounded"` settings redundant.
o.winborder = "rounded"

-- Show whitespace that actually matters.
o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", extends = "›", precedes = "‹" }

-----------------------------------------------------------------------------
-- Indentation
-----------------------------------------------------------------------------
o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.expandtab = true

-- NOTE: `smartindent` interferes with `indentexpr` (it force-reindents lines
-- starting with `#` or `}`). Tree-sitter sets `indentexpr`, so this must be off.
o.smartindent = false
o.autoindent = true

o.wrap = false
o.breakindent = true

-----------------------------------------------------------------------------
-- Files & undo
-----------------------------------------------------------------------------
o.fileformat = "unix"
o.fixendofline = true
o.swapfile = false
o.backup = false
o.undofile = true
-- 'undodir' defaults to stdpath("state")/undo and is auto-created; no need to set it.
-- (Your old ~/.vim/undodir history is still there if you ever want it back.)
o.confirm = true

-----------------------------------------------------------------------------
-- Search
-----------------------------------------------------------------------------
o.hlsearch = true -- paired with the <Esc> -> :nohlsearch mapping
o.incsearch = true
o.ignorecase = true
o.smartcase = true
o.inccommand = "split" -- live preview for :s and :g

-----------------------------------------------------------------------------
-- Splits & windows
-----------------------------------------------------------------------------
o.splitbelow = true
o.splitright = true
o.splitkeep = "screen"

-----------------------------------------------------------------------------
-- Editing
-----------------------------------------------------------------------------
o.clipboard = "unnamedplus"
o.virtualedit = "block" -- sane visual-block selection past EOL
o.updatetime = 200
o.timeoutlen = 400
vim.opt.isfname:append("@-@")

-- Required for kulala.nvim session restore (saves/restores globals across sessions)
vim.opt.sessionoptions:append("globals")

-----------------------------------------------------------------------------
-- Folding
-----------------------------------------------------------------------------
-- `foldlevelstart` is a GLOBAL-only option -- it cannot be set with opt_local.
o.foldlevelstart = 99
o.foldlevel = 99
o.foldenable = true
o.foldtext = "" -- 0.10+: syntax-highlighted fold text for free

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("kuba_folding", { clear = true }),
  callback = function(args)
    -- Skip special/scratch buffers (neo-tree, trouble, codecompanion, ...).
    if vim.bo[args.buf].buftype ~= "" then
      return
    end

    -- In Neovim 0.12+, get_parser() returns nil instead of throwing.
    local ok, parser = pcall(vim.treesitter.get_parser, args.buf, nil, { error = false })

    if ok and parser then
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    else
      vim.wo.foldmethod = "indent"
    end
  end,
})

-----------------------------------------------------------------------------
-- Misc autocmds
-----------------------------------------------------------------------------
-- Briefly highlight yanked text (vim.highlight was renamed to vim.hl in 0.11).
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("kuba_highlight_yank", { clear = true }),
  callback = function()
    (vim.hl or vim.highlight).on_yank({ timeout = 150 })
  end,
})

-- Return to the last cursor position when reopening a file.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("kuba_last_loc", { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
