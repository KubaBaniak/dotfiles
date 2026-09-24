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

-- Determine if AI plugins should be enabled (managed by kuba.core.ai)
local ai_enabled = vim.g.ai_enabled
if ai_enabled == nil then
  local ok, ai = pcall(require, "kuba.core.ai")
  ai_enabled = ok and ai.is_enabled() or (not vim.g.disable_ai and vim.env.NVIM_NO_AI ~= "1")
end

local spec = {
  -- import your plugins
  { import = "kuba.plugins" },
  { import = "kuba.plugins.lsp" },
  { import = "kuba.plugins.git" },
}

if ai_enabled then
  table.insert(spec, { import = "kuba.plugins.ai" })
end

-- Setup lazy.nvim
require("lazy").setup({
  spec = spec,
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
