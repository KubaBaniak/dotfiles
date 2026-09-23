-----------------------------------------------------------------------------
-- Diagnostics
-----------------------------------------------------------------------------
local severity = vim.diagnostic.severity

vim.diagnostic.config({
  update_in_insert = false,
  -- Without severity_sort a HINT can mask an ERROR on the same line.
  severity_sort = true,
  virtual_text = {
    spacing = 2,
    source = "if_many",
    prefix = "●",
  },
  virtual_lines = false,
  float = {
    source = "if_many",
  },
  signs = {
    text = {
      [severity.ERROR] = "󰅙 ",
      [severity.WARN] = "󰀦 ",
      [severity.HINT] = "󰠠 ",
      [severity.INFO] = "󰋽 ",
    },
    numhl = {
      [severity.ERROR] = "DiagnosticSignError",
      [severity.WARN] = "DiagnosticSignWarn",
      [severity.HINT] = "DiagnosticSignHint",
      [severity.INFO] = "DiagnosticSignInfo",
    },
  },
})

-- Global diagnostic & utility toggles
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Buffer diagnostics" })
vim.keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", { desc = "Restart LSP" })
vim.keymap.set("n", "<leader>th", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })
vim.keymap.set("n", "<leader>tl", function()
  local cfg = vim.diagnostic.config() or {}
  vim.diagnostic.config({
    virtual_lines = not cfg.virtual_lines,
    virtual_text = cfg.virtual_lines and { spacing = 2, source = "if_many", prefix = "●" } or false,
  })
end, { desc = "Toggle diagnostic virtual lines" })

-----------------------------------------------------------------------------
-- LspAttach (Buffer-local LSP mappings & 0.12 features)
-----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("kuba_lsp_attach", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
    end

    local methods = vim.lsp.protocol.Methods

    -- NOTE: Neovim 0.11+ already provides these by default:
    --   K   -> hover                 grn -> rename
    --   gra -> code action           grr -> references
    --   gri -> implementation        gO  -> document symbols
    --   gD  -> declaration           [d/ ]d -> prev/next diagnostic
    --   <C-s> (insert) -> signature help

    -- Telescope-powered navigation
    map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Go to definition")
    map("n", "gR", "<cmd>Telescope lsp_references<CR>", "Show references")
    map("n", "gI", "<cmd>Telescope lsp_implementations<CR>", "Show implementations")
    map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Show type definitions")
    map("n", "<leader>pS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "Workspace symbols")

    -- Actions & refactoring
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")

    -- 0.12: inline colour swatches (great with tailwindcss).
    if vim.lsp.document_color and client:supports_method(methods.textDocument_documentColor) then
      vim.lsp.document_color.enable(true, { bufnr = ev.buf })
    end

    -- 0.12: native paired-tag renaming for JSX/HTML.
    if vim.lsp.linked_editing_range and client:supports_method(methods.textDocument_linkedEditingRange) then
      vim.lsp.linked_editing_range.enable(true, { bufnr = ev.buf })
    end
  end,
})
