return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    -- On the main branch, setup() only accepts install_dir.
    -- Highlighting and indentation are handled via FileType autocmds below.
    require("nvim-treesitter").setup()

    local parsers = {
      "c",
      "css",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    }

    -- The main branch accepts one language or a list, not varargs.
    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "c",
        "css",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "lua",
        "markdown",
        "typescript",
        "typescriptreact",
        "vim",
        "yaml",
      },
      callback = function()
        if not pcall(vim.treesitter.start) then
          return
        end

        -- Treesitter-based indentation is still experimental. Markdown keeps
        -- its runtime indentation because Tree-sitter does not provide it.
        if vim.bo.filetype ~= "markdown" then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
