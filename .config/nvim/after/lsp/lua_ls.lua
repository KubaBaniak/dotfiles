-- Neovim 0.11+ convention: files in `after/lsp/<server>.lua` simply RETURN a
-- config table, which is merged on top of the base config from nvim-lspconfig.
-- No need to call vim.lsp.config() here.
return {
  settings = {
    Lua = {
      -- lazydev.nvim handles the workspace library, so keep this minimal.
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
      },
      hint = {
        enable = true,
        arrayIndex = "Disable",
      },
      format = {
        -- stylua handles formatting via conform.nvim
        enable = false,
      },
      telemetry = { enable = false },
    },
  },
}
