return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    -- Lazy-load: previously the keymap lived in config(), so neo-tree and all
    -- of its dependencies loaded on every startup.
    cmd = "Neotree",
    keys = {
      -- Jump INTO the explorer (and back out again).
      -- `action=focus` is neo-tree's default, so a bare :Neotree opens AND
      -- moves the cursor there. `reveal` additionally highlights the file you
      -- were just editing. If the cursor is already in the tree, hop back to
      -- the window you came from -- so this key ping-pongs.
      {
        "<leader>e",
        function()
          if vim.bo.filetype == "neo-tree" then
            vim.cmd.wincmd("p") -- back to the previous window
          else
            vim.cmd("Neotree focus reveal")
          end
        end,
        desc = "Jump to/from file explorer",
      },

      -- Open/close the sidebar entirely.
      -- NOTE: `toggle` CLOSES the tree if it is open, even when your cursor is
      -- in the editor -- that's why it is not the right key for "jump to it".
      { "<leader>nt", "<cmd>Neotree toggle<CR>", desc = "Toggle file explorer" },

      { "<leader>nf", "<cmd>Neotree focus reveal<CR>", desc = "Reveal current file" },
      { "<leader>nb", "<cmd>Neotree buffers toggle<CR>", desc = "Buffer explorer" },
      { "<leader>ng", "<cmd>Neotree git_status toggle<CR>", desc = "Git status explorer" },

      -- Open it without stealing focus.
      { "<leader>ns", "<cmd>Neotree show<CR>", desc = "Show explorer (keep focus)" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "s1n7ax/nvim-window-picker",
    },
    -- netrw is disabled, and neo-tree is lazy-loaded, so `nvim .` would open an
    -- empty buffer. Force-load neo-tree when nvim is started on a directory.
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = (vim.uv or vim.loop).fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      -- popup_border_style is inherited from the global 'winborder' option,
      -- but neo-tree needs "" to defer to it.
      popup_border_style = "",
      close_if_last_window = false,
      enable_diagnostics = true,

      source_selector = {
        winbar = true,
        tabs_layout = "equal",
      },

      filesystem = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        use_libuv_file_watcher = true,
        -- netrw is disabled in lazy's performance settings, so let neo-tree
        -- take over directory arguments (e.g. `nvim .`).
        hijack_netrw_behavior = "open_current",
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },

      buffers = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        group_empty_dirs = true,
      },

      window = {
        width = 34,
        mappings = {
          ["P"] = {
            "toggle_preview",
            config = { use_float = true },
          },
          ["w"] = "open_with_window_picker",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
        },
      },
    },
  },

  {
    "antosha417/nvim-lsp-file-operations",
    event = "LspAttach",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  {
    "s1n7ax/nvim-window-picker",
    version = "2.*",
    lazy = true,
    opts = {
      filter_rules = {
        include_current_win = false,
        autoselect_one = true,
        bo = {
          filetype = { "neo-tree", "neo-tree-popup", "notify" },
          buftype = { "terminal", "quickfix" },
        },
      },
    },
  },
}
