return {
  "saghen/blink.cmp",
  version = "1.*",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      dependencies = { "rafamadriz/friendly-snippets" },
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    { "fang2hou/blink-copilot" },
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' = <C-y> accepts, <C-n>/<C-p> navigate, <C-e> hides,
    -- <C-space> opens menu/docs, <C-k> toggles signature help.
    keymap = { preset = "default" },

    snippets = { preset = "luasnip" },

    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        -- border inherited from the global 'winborder' option
      },
      ghost_text = { enabled = true },
      accept = { auto_brackets = { enabled = false } },
    },

    -- Completion on the `:` and `/` command lines.
    cmdline = {
      enabled = true,
      keymap = { preset = "cmdline" },
      sources = { "cmdline", "buffer" },
      completion = {
        menu = { auto_show = true },
        ghost_text = { enabled = true },
        list = { selection = { preselect = false, auto_insert = true } },
      },
    },

    -- Completion inside :terminal.
    terminal = {
      enabled = true,
      keymap = { preset = "terminal" },
      sources = { "buffer" },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer", "copilot" },

      per_filetype = {
        -- inherit_defaults keeps path/buffer/snippets available instead of
        -- replacing the source list outright.
        lua = { inherit_defaults = true, "lazydev" },
        codecompanion = { inherit_defaults = true, "codecompanion" },
        codecompanion_input = { inherit_defaults = true, "codecompanion" },
      },

      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
        },
        codecompanion = {
          name = "CodeCompanion",
          module = "codecompanion.providers.completion.blink",
          score_offset = 100,
          async = true,
        },
      },
    },

    signature = {
      enabled = true,
      window = { show_documentation = true },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
