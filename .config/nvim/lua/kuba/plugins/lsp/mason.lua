return {
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = {
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "lua_ls",
        "eslint",
        "jsonls",
        -- NOTE: "copilot" was removed -- it is not an lspconfig server you want
        -- here. Copilot is provided by zbirenbaum/copilot.lua; listing it would
        -- start a second, conflicting Copilot client.
      },
      -- Servers installed via Mason are enabled automatically (vim.lsp.enable
      -- is called for you). Stated explicitly so the behaviour is obvious.
      automatic_enable = true,
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
