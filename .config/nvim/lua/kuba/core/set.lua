vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.fileformat = "unix"
vim.opt.fixendofline = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.guifont = "Iosevka Nerd Font"

vim.api.nvim_create_autocmd({ "FileType" }, {
  callback = function(args)
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
    vim.opt.foldenable = true

    -- In Neovim 0.12+, get_parser() no longer throws on failure -- it returns nil.
    -- We capture both the ok status and the parser itself.
    local ok, parser = pcall(vim.treesitter.get_parser, args.buf)

    if ok and parser then
      vim.opt_local.foldmethod = "expr"
      vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    else
      vim.opt_local.foldmethod = "syntax"
    end
  end,
})
