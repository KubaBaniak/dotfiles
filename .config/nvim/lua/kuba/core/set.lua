vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.winborder = "rounded"

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.guifont = "Iosevka Nerd Font"

vim.api.nvim_create_autocmd({ "FileType" }, {
  callback = function()
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
    vim.opt.foldenable = true
    if require("nvim-treesitter.parsers").has_parser() then
      vim.opt_local.foldmethod = "expr"
      vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    else
      vim.opt_local.foldmethod = "syntax" -- fallback jeśli brak parsera
    end
  end,
})
