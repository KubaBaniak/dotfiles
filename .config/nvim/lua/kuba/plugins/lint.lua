return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      -- eslint_d is a daemon; far faster than invoking eslint per-lint.
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    }

    -- Don't spam errors in projects that have no eslint config at all.
    local eslint = lint.linters.eslint_d
    if eslint then
      eslint.args = vim.list_extend({ "--no-warn-ignored" }, eslint.args or {})
    end

    local function try_lint()
      -- The `eslint` LSP already reports diagnostics. If it's attached to this
      -- buffer, skip nvim-lint to avoid duplicate diagnostics.
      local has_eslint_lsp = #vim.lsp.get_clients({ bufnr = 0, name = "eslint" }) > 0
      if has_eslint_lsp then
        return
      end
      lint.try_lint()
    end

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("kuba_lint", { clear = true }),
      callback = function()
        vim.schedule(try_lint)
      end,
    })

    vim.keymap.set("n", "<leader>ml", try_lint, { desc = "Lint buffer" })
  end,
}
