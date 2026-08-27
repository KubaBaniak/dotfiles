-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "kuba.plugins" },
    { import = "kuba.plugins.lsp" },
    { import = "kuba.plugins.ai" },
    { import = "kuba.plugins.git" },
  },
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "catppuccin-mocha", "habamax" } },

  -- Check for updates in the background, but don't interrupt with popups.
  checker = { enabled = true, notify = false, frequency = 86400 },
  change_detection = { enabled = true, notify = false },

  ui = { border = "rounded" },

  performance = {
    rtp = {
      -- Disable unused built-in plugins to cut startup time.
      disabled_plugins = {
        "gzip",
        "netrwPlugin", -- neo-tree hijacks directory buffers instead
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
