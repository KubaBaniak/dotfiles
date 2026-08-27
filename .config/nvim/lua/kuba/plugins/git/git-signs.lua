return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    current_line_blame = false,
    current_line_blame_opts = {
      delay = 300,
      virt_text_pos = "eol",
    },
    on_attach = function(bufnr)
      local gs = require("gitsigns")

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
      end

      ---------------------------------------------------------------------
      -- Navigation
      ---------------------------------------------------------------------
      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Next git hunk")

      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Prev git hunk")

      ---------------------------------------------------------------------
      -- Staging
      ---------------------------------------------------------------------
      -- stage_hunk() now TOGGLES staging on an already-staged hunk.
      -- `undo_stage_hunk` was removed upstream.
      map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
      map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")

      -- Visual mode REQUIRES an explicit line range, otherwise it silently
      -- operates on the whole hunk under the cursor instead of the selection.
      map("v", "<leader>gs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage selected lines")

      map("v", "<leader>gr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Reset selected lines")

      map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
      map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
      -- Replacement for the old undo_stage_hunk: unstage the whole file.
      map("n", "<leader>gu", gs.reset_buffer_index, "Unstage buffer")

      ---------------------------------------------------------------------
      -- Preview / blame / diff
      ---------------------------------------------------------------------
      map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
      map("n", "<leader>gi", gs.preview_hunk_inline, "Preview hunk inline")
      map("n", "<leader>gb", gs.toggle_current_line_blame, "Toggle line blame")
      map("n", "<leader>gB", function()
        gs.blame_line({ full = true })
      end, "Blame line (full)")
      map("n", "<leader>gw", gs.toggle_word_diff, "Toggle word diff")

      map("n", "<leader>gf", gs.diffthis, "Diff this file")
      map("n", "<leader>gF", function()
        gs.diffthis("~")
      end, "Diff this file against ~")

      ---------------------------------------------------------------------
      -- Quickfix
      ---------------------------------------------------------------------
      map("n", "<leader>gq", gs.setqflist, "Hunks -> quickfix (buffer)")
      map("n", "<leader>gQ", function()
        gs.setqflist("all")
      end, "Hunks -> quickfix (repo)")

      ---------------------------------------------------------------------
      -- Text object
      ---------------------------------------------------------------------
      -- Docs now use the Lua function directly rather than the legacy
      -- `:<C-U>Gitsigns select_hunk<CR>` cmdline form.
      map({ "o", "x" }, "ih", gs.select_hunk, "Select git hunk")
    end,
  },
}
