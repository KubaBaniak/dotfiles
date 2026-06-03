vim.lsp.config("ts_ls", {
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, {
      "tsconfig.json",
      "tsconfig.base.json",
      "package.json",
    })

    if root then
      return on_dir(root)
    end

    -- fallback, żeby LSP zawsze się uruchomił
    local git_root = vim.fs.root(bufnr, { ".git" })
    on_dir(git_root or vim.fn.getcwd())
  end,

  init_options = {
    preferences = {
      -- prefer `import type` for type-only imports
      preferTypeOnlyAutoImports = true,

      -- use relative imports in auto-import suggestions
      importModuleSpecifierPreference = "relative",

      -- include snippet completions
      includeCompletionsWithSnippetText = true,

      -- auto-import from module exports
      includeCompletionsForModuleExports = true,

      -- inlay hints
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayVariableTypeHintsWhenTypeMatchesName = false,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
    },
    implicitProjectConfiguration = {
      strict = true,
      strictNullChecks = true,
      noImplicitAny = true,
      strictBindCallApply = true,
      noUnusedLocals = true,
      noUnusedParameters = true,
      noImplicitReturns = true,
      noImplicitOverride = true,
      exactOptionalPropertyTypes = true,
    },
  },
})

return {}
