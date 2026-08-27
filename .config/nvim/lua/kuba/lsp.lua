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
  -- 0.11+: much richer multi-line diagnostics. Off by default, toggled with <leader>tl.
  virtual_lines = false,
  float = {
    source = "if_many",
    -- border comes from the global 'winborder' option now
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

-----------------------------------------------------------------------------
-- LspAttach
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

    -- NOTE: Neovim 0.11 already provides these by default, so they are NOT remapped here:
    --   K    -> vim.lsp.buf.hover        grn -> rename
    --   gra  -> code action              grr -> references
    --   gri  -> implementation           gO  -> document symbols
    --   <C-s> (insert) -> signature help
    -- The mappings below are the Telescope-powered / extra ones.

    map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    map("n", "gR", "<cmd>Telescope lsp_references<CR>", "Show references")
    map("n", "gI", "<cmd>Telescope lsp_implementations<CR>", "Show implementations")
    map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Show type definitions")
    -- Document symbols are available via the built-in `gO`; this is the workspace-wide picker.
    map("n", "<leader>pS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "Workspace symbols")

    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("n", "<leader>rs", "<cmd>LspRestart<CR>", "Restart LSP")

    -- Diagnostics (float = true is why these override the 0.11 defaults)
    map("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Buffer diagnostics")
    map("n", "<leader>d", vim.diagnostic.open_float, "Line diagnostics")
    map("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, "Previous diagnostic")
    map("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, "Next diagnostic")

    -- Toggle 0.11 virtual_lines diagnostics
    map("n", "<leader>tl", function()
      local cfg = vim.diagnostic.config()
      vim.diagnostic.config({
        virtual_lines = not cfg.virtual_lines,
        virtual_text = cfg.virtual_lines and { spacing = 2, source = "if_many", prefix = "●" } or false,
      })
    end, "Toggle diagnostic virtual lines")

    -------------------------------------------------------------------------
    -- Capability-gated features
    -------------------------------------------------------------------------

    -- Inlay hints: enable by default, not just on manual toggle.
    if client:supports_method(methods.textDocument_inlayHint) then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
      map("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
      end, "Toggle inlay hints")
    end

    -- Highlight other references to the symbol under the cursor (uses 'updatetime').
    if client:supports_method(methods.textDocument_documentHighlight) then
      local hl_group = vim.api.nvim_create_augroup("kuba_lsp_highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = hl_group,
        buffer = ev.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = hl_group,
        buffer = ev.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end

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

-----------------------------------------------------------------------------
-- Detach cleanup
-----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("LspDetach", {
  group = vim.api.nvim_create_augroup("kuba_lsp_detach", { clear = true }),
  callback = function(ev)
    pcall(vim.api.nvim_clear_autocmds, { group = "kuba_lsp_highlight", buffer = ev.buf })
    pcall(vim.lsp.buf.clear_references)
  end,
})
