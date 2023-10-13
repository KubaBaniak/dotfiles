local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettierd.with({
      condition = function(utils)
        return utils.root_has_file({ ".prettierrc" })
      end,
    }),
    null_ls.builtins.formatting.prismaFmt,
  },
})
