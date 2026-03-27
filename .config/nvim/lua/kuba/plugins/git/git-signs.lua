return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  opts = {
    signs = {
      add          = { text = "▎" },
      change       = { text = "▎" },
      delete       = { text = "" },
      topdelete    = { text = "" },
      changedelete = { text = "▎" },
      untracked    = { text = "▎" },
    },
    current_line_blame = false,
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local opts = { buffer = bufnr, silent = true }

      -- Hunk navigation
      opts.desc = "Next git hunk"
      vim.keymap.set("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, opts)

      opts.desc = "Prev git hunk"
      vim.keymap.set("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, opts)

      -- Staging
      opts.desc = "Stage hunk"
      vim.keymap.set({ "n", "v" }, "<leader>gs", gs.stage_hunk, opts)

      opts.desc = "Reset hunk"
      vim.keymap.set({ "n", "v" }, "<leader>gr", gs.reset_hunk, opts)

      opts.desc = "Stage buffer"
      vim.keymap.set("n", "<leader>gS", gs.stage_buffer, opts)

      opts.desc = "Undo stage hunk"
      vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, opts)

      opts.desc = "Reset buffer"
      vim.keymap.set("n", "<leader>gR", gs.reset_buffer, opts)

      -- Preview / blame
      opts.desc = "Preview hunk"
      vim.keymap.set("n", "<leader>gp", gs.preview_hunk, opts)

      opts.desc = "Toggle line blame"
      vim.keymap.set("n", "<leader>gb", gs.toggle_current_line_blame, opts)

      opts.desc = "Blame line (full)"
      vim.keymap.set("n", "<leader>gB", function() gs.blame_line({ full = true }) end, opts)

      opts.desc = "Toggle deleted lines"
      vim.keymap.set("n", "<leader>gD", gs.toggle_deleted, opts)

      -- Text object: select hunk
      vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { buffer = bufnr, desc = "Select git hunk" })
    end,
  },
}
