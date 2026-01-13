return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "FormatDisable", "FormatEnable" },
  init = function()
    -- Initialize the mode to Global (false) or Hunks (true)
    vim.g.format_modifications_only = false
    vim.g.disable_autoformat = false
  end,
  config = function()
    local conform = require("conform")
    local notify = vim.notify

    -----------------------------------------------------------------------------
    -- Constants & Settings
    -----------------------------------------------------------------------------
    local default_opts = {
      lsp_fallback = true,
      async = false,
      timeout_ms = 3000, -- Increased timeout to prevent premature failures
    }

    local formatters_by_ft = {
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      -- Fixed: 'go' is the correct filetype, and use standard tools or fallback to LSP
      go = { "goimports", "gofumpt" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      lua = { "stylua" },
      python = { "isort", "black" },
    }

    -----------------------------------------------------------------------------
    -- Helper: Format Hunks (Smart Format)
    -----------------------------------------------------------------------------
    local function format_hunks()
      local status, gitsigns = pcall(require, "gitsigns")
      if not status then
        -- Fallback to global format if gitsigns is missing
        return conform.format(default_opts)
      end

      local hunks = gitsigns.get_hunks()
      if not hunks or #hunks == 0 then
        notify("No git changes to format", vim.log.levels.INFO)
        return
      end

      local format_count = 0

      -- Iterate backwards to prevent line indices from shifting during format
      for i = #hunks, 1, -1 do
        local hunk = hunks[i]
        if hunk and hunk.type ~= "delete" then
          local start_line = hunk.added.start
          local end_line = start_line + hunk.added.count

          if start_line > 0 and end_line >= start_line then
            conform.format({
              async = false,
              lsp_fallback = default_opts.lsp_fallback,
              timeout_ms = default_opts.timeout_ms,
              range = {
                ["start"] = { start_line, 0 },
                ["end"] = { end_line, 0 },
              },
            })
            format_count = format_count + 1
          end
        end
      end

      if format_count > 0 then
        notify("Formatted " .. format_count .. " git hunk(s)", vim.log.levels.INFO)
      end
    end

    -----------------------------------------------------------------------------
    -- Helper: Toggle Formatting Mode
    -----------------------------------------------------------------------------
    local function toggle_format_mode()
      -- If formatting was explicitly disabled via command, re-enable it first
      if vim.g.disable_autoformat then
        vim.g.disable_autoformat = false
      end

      -- Toggle the boolean flag
      vim.g.format_modifications_only = not vim.g.format_modifications_only

      if vim.g.format_modifications_only then
        notify("Git chunk formatting enabled", vim.log.levels.INFO, { title = "Conform" })
      else
        notify("Global format enabled", vim.log.levels.INFO, { title = "Conform" })
      end
    end

    -----------------------------------------------------------------------------
    -- Setup
    -----------------------------------------------------------------------------
    conform.setup({
      formatters_by_ft = formatters_by_ft,
      format_on_save = function(bufnr)
        -- 1. Check if manually disabled
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        -- 2. Check if in "Git Hunk Only" mode
        if vim.g.format_modifications_only then
          format_hunks()
          return -- Return nil so conform doesn't double-format
        end

        -- 3. Standard Global Formatting
        return default_opts
      end,
    })

    -----------------------------------------------------------------------------
    -- Commands & Keymaps
    -----------------------------------------------------------------------------
    -- Commands to completely disable formatting if needed
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
      notify("Autoformat-on-save disabled", vim.log.levels.INFO, { title = "Conform" })
    end, { desc = "Disable autoformat-on-save", bang = true })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
      notify("Autoformat-on-save re-enabled", vim.log.levels.INFO, { title = "Conform" })
    end, { desc = "Re-enable autoformat-on-save" })

    -- Trigger Smart Format manually (One-off)
    vim.keymap.set({ "n", "v" }, "<leader>mp", format_hunks, { desc = "Smart Format (Git Hunks)" })

    -- Toggle between Global and Git Chunk modes
    vim.keymap.set("n", "cf", toggle_format_mode, { desc = "Toggle Formatting Mode" })
  end,
}
