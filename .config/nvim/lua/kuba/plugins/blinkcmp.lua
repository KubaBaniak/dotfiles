local ai_enabled = vim.g.ai_enabled ~= false and vim.env.NVIM_NO_AI ~= "1" and not vim.g.disable_ai

local dependencies = {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}
if ai_enabled then
  table.insert(dependencies, { "fang2hou/blink-copilot" })
end

local default_sources = { "lsp", "path", "snippets", "buffer" }
if ai_enabled then
  table.insert(default_sources, "copilot")
end

local per_filetype = {
  -- inherit_defaults keeps path/buffer/snippets available instead of
  -- replacing the source list outright.
  lua = { inherit_defaults = true, "lazydev" },
}
if ai_enabled then
  per_filetype.codecompanion = { inherit_defaults = true, "codecompanion" }
  per_filetype.codecompanion_input = { inherit_defaults = true, "codecompanion" }
end

local providers = {
  lazydev = {
    name = "LazyDev",
    module = "lazydev.integrations.blink",
    score_offset = 100,
  },
}
if ai_enabled then
  providers.copilot = {
    name = "copilot",
    module = "blink-copilot",
    score_offset = 100,
    async = true,
  }
  providers.codecompanion = {
    name = "CodeCompanion",
    module = "codecompanion.providers.completion.blink",
    score_offset = 100,
    async = true,
  }
end

return {
  "saghen/blink.cmp",
  version = "1.*",
  lazy = false, -- Load early so plugin/blink-cmp.lua registers LSP capabilities before servers start
  dependencies = dependencies,
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
      default = default_sources,
      per_filetype = per_filetype,
      providers = providers,
    },

    signature = {
      enabled = true,
      window = { show_documentation = true },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
