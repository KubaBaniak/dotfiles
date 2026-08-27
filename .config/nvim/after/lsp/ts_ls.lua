-- Neovim 0.11+ convention: return a table, don't call vim.lsp.config().
return {
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, {
      "tsconfig.json",
      "tsconfig.base.json",
      "jsconfig.json",
      "package.json",
    })

    if root then
      return on_dir(root)
    end

    -- Fallback so the LSP always starts, even outside a project.
    on_dir(vim.fs.root(bufnr, { ".git" }) or vim.fn.getcwd())
  end,

  init_options = {
    preferences = {
      -- prefer `import type` for type-only imports
      preferTypeOnlyAutoImports = true,

      -- prefer path-alias imports (~/...) over relative imports
      importModuleSpecifierPreference = "non-relative",

      includeCompletionsWithSnippetText = true,
      includeCompletionsForModuleExports = true,

      -- Inlay hints. These are inert unless the client enables them --
      -- lsp.lua now calls vim.lsp.inlay_hint.enable(true) on attach.
      includeInlayParameterNameHints = "literals",
      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      includeInlayFunctionParameterTypeHints = false,
      includeInlayVariableTypeHints = false,
      includeInlayVariableTypeHintsWhenTypeMatchesName = false,
      includeInlayPropertyDeclarationTypeHints = false,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
    },

    -- NOTE: this only applies to files NOT covered by a tsconfig.json.
    -- Inside a real project your tsconfig always wins.
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
}
