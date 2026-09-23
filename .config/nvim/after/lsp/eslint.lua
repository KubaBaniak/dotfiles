return {
  settings = {
    workingDirectory = { mode = "auto" },
    format = false,
  },

  on_attach = function(client, bufnr)
    local function fix_all()
      client:request_sync("workspace/executeCommand", {
        command = "eslint.applyAllFixes",
        arguments = {
          {
            uri = vim.uri_from_bufnr(bufnr),
            version = vim.lsp.util.buf_versions[bufnr],
          },
        },
      }, 3000, bufnr)
    end

    vim.api.nvim_buf_create_user_command(bufnr, "LspEslintFixAll", fix_all, { desc = "Fix all ESLint problems" })

    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("kuba_eslint_fix_" .. bufnr, { clear = true }),
      buffer = bufnr,
      callback = function()
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        fix_all()
      end,
    })

    vim.keymap.set("n", "<leader>mf", fix_all, {
      buffer = bufnr,
      desc = "ESLint fix all",
    })
  end,
}
