return {
  "NeogitOrg/neogit",
  lazy = true,
  cmd = "Neogit",
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "esmuellert/codediff.nvim",
  },
  init = function()
    -- Shim codediff.ui.view.create for legacy Neogit integration schema
    local ok, view = pcall(require, "codediff.ui.view")
    if ok and view.create then
      local original_create = view.create
      local path = require("codediff.core.path")

      view.create = function(session_config, filetype, on_ready)
        if session_config.mode == "explorer" and not session_config.panel then
          session_config.panel = {
            name = "explorer",
            data = session_config.explorer_data or {},
          }
          session_config.original = session_config.original or path.empty()
          session_config.modified = session_config.modified or path.empty()
        end
        return original_create(session_config, filetype, on_ready)
      end
    end
  end,
  config = function()
    require("neogit").setup({
      disable_insert_on_commit = "auto",
      process_spinner = true,
      prompt_force_push = true,
      prompt_amend_commit = true,
      graph_style = "kitty",
      kind = "tab",
      commit_editor = {
        kind = "tab",
        show_staged_diff = true,
        staged_diff_split_kind = "auto",
        spell_check = true,
      },
      remember_settings = true,
      use_per_project_settings = true,
      sections = {
        stashes = { folded = true, hidden = false },
        unpulled_upstream = { folded = true, hidden = false },
        recent = { folded = true, hidden = false },
      },
      integrations = {
        telescope = true,
        codediff = true,
      },
    })
  end,
}
