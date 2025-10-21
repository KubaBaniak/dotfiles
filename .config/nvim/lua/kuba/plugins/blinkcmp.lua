return {
  "saghen/blink.cmp",
  version = "1.*",
  dependencies = { { "L3MON4D3/LuaSnip", version = "v2.*" }, { "fang2hou/blink-copilot" } },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    snippets = { preset = "luasnip" },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = { documentation = { auto_show = true }, ghost_text = { enabled = true } },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "copilot" },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
        },
      },
    },
    signature = { enabled = true },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
