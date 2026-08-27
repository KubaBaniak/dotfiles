return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "ConformInfo", "FormatDisable", "FormatEnable" },
  init = function()
    vim.g.format_modifications_only = false
    vim.g.disable_autoformat = false
  end,
  config = function()
    local conform = require("conform")

    local function notify(msg, level)
      vim.notify(msg, level or vim.log.levels.INFO, { title = "Conform" })
    end

    ---------------------------------------------------------------------------
    -- Setup
    ---------------------------------------------------------------------------
    conform.setup({
      -- Shared options for every format call (manual, on-save, range).
      default_format_opts = {
        lsp_format = "fallback",
        timeout_ms = 3000,
      },

      formatters_by_ft = {
        -- prettierd is a long-lived daemon: dramatically faster on save.
        -- stop_after_first means prettier is only used if prettierd is missing.
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        graphql = { "prettierd", "prettier", stop_after_first = true },
        lua = { "stylua" },
        sh = { "shfmt" },

        -- Fallback for filetypes with no configured formatter.
        ["markdown.mdx"] = { "prettierd", "prettier", stop_after_first = true },
        ["_"] = { "trim_whitespace" },
      },

      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return nil
        end
        -- Hunk-only mode is handled by the BufWritePre autocmd below.
        if vim.g.format_modifications_only then
          return nil
        end
        return { lsp_format = "fallback", timeout_ms = 3000 }
      end,
    })

    ---------------------------------------------------------------------------
    -- Format only changed git hunks
    ---------------------------------------------------------------------------
    local function format_hunks(bufnr)
      bufnr = bufnr or vim.api.nvim_get_current_buf()

      local ok, gitsigns = pcall(require, "gitsigns")
      if not ok then
        return conform.format({ bufnr = bufnr, lsp_format = "fallback", timeout_ms = 3000 })
      end

      local hunks = gitsigns.get_hunks(bufnr)
      if not hunks or #hunks == 0 then
        return
      end

      -- Iterate backwards so earlier ranges stay valid as later ones shift.
      for i = #hunks, 1, -1 do
        local hunk = hunks[i]
        if hunk and hunk.type ~= "delete" then
          local start_line = hunk.added.start
          local end_line = start_line + math.max(hunk.added.count - 1, 0)

          if start_line > 0 then
            conform.format({
              bufnr = bufnr,
              async = false,
              lsp_format = "fallback",
              timeout_ms = 3000,
              range = {
                ["start"] = { start_line, 0 },
                ["end"] = { end_line, 0 },
              },
            })
          end
        end
      end
    end

    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("kuba_conform_hunks", { clear = true }),
      callback = function(args)
        if vim.g.disable_autoformat or vim.b[args.buf].disable_autoformat then
          return
        end
        if vim.g.format_modifications_only then
          format_hunks(args.buf)
        end
      end,
    })

    ---------------------------------------------------------------------------
    -- Commands
    ---------------------------------------------------------------------------
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        vim.b.disable_autoformat = true
        notify("Autoformat disabled for this buffer")
      else
        vim.g.disable_autoformat = true
        notify("Autoformat disabled globally")
      end
    end, { desc = "Disable autoformat-on-save", bang = true })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
      notify("Autoformat re-enabled")
    end, { desc = "Re-enable autoformat-on-save" })

    ---------------------------------------------------------------------------
    -- Keymaps
    ---------------------------------------------------------------------------
    -- Format buffer / selection now.
    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({ async = true, lsp_format = "fallback" })
    end, { desc = "Format buffer/selection" })

    -- Format only the git hunks, on demand.
    vim.keymap.set("n", "<leader>mh", function()
      format_hunks()
    end, { desc = "Format git hunks" })

    -- NOTE: this used to be `tf`, which broke the built-in `t` (till) motion.
    vim.keymap.set("n", "<leader>tf", function()
      if vim.g.disable_autoformat then
        vim.g.disable_autoformat = false
      end
      vim.g.format_modifications_only = not vim.g.format_modifications_only
      notify(vim.g.format_modifications_only and "Format mode: git hunks only" or "Format mode: whole buffer")
    end, { desc = "Toggle format mode (buffer/hunks)" })
  end,
}
