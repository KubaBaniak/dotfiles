return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "FormatDisable", "FormatEnable" }, -- Lazy load commands
  init = function()
    vim.g.format_modifications_only = false
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
      timeout_ms = 500,
    }

    local formatters_by_ft = {
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
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
      -- 1. Check for Gitsigns
      local status, gitsigns = pcall(require, "gitsigns")
      if not status then
        return conform.format(default_opts)
      end

      -- 2. Check for Hunks
      local hunks = gitsigns.get_hunks()
      if not hunks or #hunks == 0 then
        conform.format(default_opts)
        notify("Formatted entire file (No git changes)", vim.log.levels.INFO)
        return
      end

      -- 3. Format Specific Hunks
      local format_count = 0
      for i = #hunks, 1, -1 do
        local hunk = hunks[i]
        if hunk and hunk.type ~= "delete" then
          local start_line = hunk.added.start
          local end_line = start_line + hunk.added.count

          if start_line > 0 and end_line >= start_line then
            conform.format({
              async = false,
              lsp_fallback = false,
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
      else
        notify("No added lines to format", vim.log.levels.INFO)
      end
    end

    -----------------------------------------------------------------------------
    -- Helper: Toggle Formatting
    -----------------------------------------------------------------------------
    local function toggle_format()
      if vim.g.disable_autoformat then
        vim.cmd("FormatEnable")
        notify("Formatting enabled", vim.log.levels.INFO, { title = "Conform" })
      else
        vim.cmd("FormatDisable")
        notify("Formatting disabled", vim.log.levels.INFO, { title = "Conform" })
      end
    end

    -----------------------------------------------------------------------------
    -- Setup
    -----------------------------------------------------------------------------
    conform.setup({
      formatters_by_ft = formatters_by_ft,
      format_on_save = function(bufnr)
        -- Check if disabled
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        -- Check modification mode
        if vim.g.format_modifications_only then
          format_hunks()
          return
        end

        return default_opts
      end,
    })

    -----------------------------------------------------------------------------
    -- Commands & Keymaps
    -----------------------------------------------------------------------------
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, { desc = "Disable autoformat-on-save", bang = true })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, { desc = "Re-enable autoformat-on-save" })

    -- Trigger Smart Format manually
    vim.keymap.set({ "n", "v" }, "<leader>mp", format_hunks, { desc = "Smart Format (Git Hunks)" })

    -- Toggle Autoformat
    vim.keymap.set("n", "cf", toggle_format, { desc = "Toggle Formatting" })
  end,
}
