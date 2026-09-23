return {
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = {
        "ts_ls",
        "html",
        "cssls",
        "css_variables",
        "tailwindcss",
        "lua_ls",
        "eslint",
        "jsonls",
        "prismals",
      },
      automatic_enable = {
        exclude = { "copilot", "stylua" },
      },
    },
    dependencies = {
      -- mason.nvim must be set up BEFORE mason-lspconfig; listing it as a
      -- dependency guarantees that ordering.
      {
        "mason-org/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonLog" },
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      "neovim/nvim-lspconfig",
    },
  },

  -- Formatters / linters (things mason-lspconfig does not cover).
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "prettierd",
        "prettier",
        "stylua",
        "shfmt",
      },
      run_on_start = true,
    },
  },
}
