return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    -- On the main branch, setup() only accepts install_dir.
    -- Highlighting and indentation are handled via FileType autocmds below.
    require("nvim-treesitter").setup()

    -- Install parsers (replaces the old ensure_installed option)
    require("nvim-treesitter.install").install(
      "c",
      "lua",
      "vim",
      "vimdoc",
      "typescript",
      "javascript",
      "tsx",
      "html",
      "yaml"
    )

    -- Enable treesitter features per filetype
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "c", "lua", "vim", "typescript", "javascript", "tsx", "html", "yaml" },
      callback = function()
        -- Built-in Neovim treesitter highlighting
        local ok = pcall(vim.treesitter.start)
        if not ok then
          return
        end

        -- Treesitter-based indentation (experimental)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
