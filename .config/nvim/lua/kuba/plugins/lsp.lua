-- your keymaps
local function global_on_attach(client, bufnr)
  local opts = { buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end

return {
  -- Mason (installer)
  {
    "williamboman/mason.nvim",
    opts = {},
  },

  -- Mason ↔ LSP (ensure + auto setup)
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "saghen/blink.cmp",
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
    },
    opts = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      return {
        ensure_installed = { "ts_ls", "eslint", "html", "rust_analyzer", "lua_ls", "copilot" },
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
              on_attach = global_on_attach,
            })
          end,
        },
      }
    end,
  },
}
