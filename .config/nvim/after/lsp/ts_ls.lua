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
})
