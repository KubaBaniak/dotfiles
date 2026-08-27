-- The eslint language server exposes an `EslintFixAll` command.
-- Running it on save gives you autofix (unused imports, import order, etc.)
-- which conform/prettier cannot do on its own.
return {
  settings = {
    -- Use flat config (eslint.config.js) when present.
    experimental = { useFlatConfig = false },
    workingDirectories = { mode = "auto" },
    format = false, -- prettier handles formatting via conform
  },

  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("kuba_eslint_fix_" .. bufnr, { clear = true }),
      buffer = bufnr,
      callback = function()
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        -- EslintFixAll is provided by the eslint server integration.
        pcall(vim.cmd, "EslintFixAll")
      end,
    })

    vim.keymap.set("n", "<leader>mf", "<cmd>EslintFixAll<CR>", {
      buffer = bufnr,
      desc = "ESLint fix all",
    })
  end,
}
