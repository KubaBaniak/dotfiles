return {
  "esmuellert/codediff.nvim",
  lazy = true,
  cmd = "CodeDiff",
  keys = {
    { "<leader>gd", "<cmd>CodeDiff<cr>",              desc = "Diff working tree (explorer)" },
    { "<leader>gh", "<cmd>CodeDiff history HEAD~50 %<cr>", desc = "File history (current file)" },
    { "<leader>gH", "<cmd>CodeDiff history<cr>",      desc = "File history (repo)" },
    { "<leader>gx", "<cmd>tabclose<cr>",              desc = "Close CodeDiff tab" },
  },
  opts = {
    diff = {
      layout = "side-by-side",
      disable_inlay_hints = true,
      ignore_trim_whitespace = false,
      cycle_next_hunk = true,
      cycle_next_file = true,
      jump_to_first_change = true,
      compute_moves = false,
    },
    explorer = {
      position = "left",
      width = 35,
      listing_style = "tree",
      flatten_dirs = true,
      initial_focus = "explorer",
      icons = {
        folder_closed = "",
        folder_open = "",
      },
    },
    history = {
      position = "bottom",
      height = 16,
      initial_focus = "history",
    },
    highlights = {
      line_insert = "DiffAdd",
      line_delete = "DiffDelete",
    },
    keymaps = {
      view = {
        quit = "q",
        next_hunk = "]c",
        prev_hunk = "[c",
        next_file = "]f",
        prev_file = "[f",
        diff_get = "do",
        diff_put = "dp",
        toggle_layout = "t",
        show_help = "g?",
      },
      explorer = {
        select = "<CR>",
        hover = "K",
        refresh = "R",
        toggle_view_mode = "i",
        stage_all = "S",
        unstage_all = "U",
        restore = "X",
      },
      history = {
        select = "<CR>",
        toggle_view_mode = "i",
        refresh = "R",
      },
    },
  },
}
