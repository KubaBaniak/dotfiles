return {
  'mhartington/formatter.nvim',
  config = function()
    require("formatter").setup {
      logging = false,
      log_level = vim.log.levels.WARN,
      filetype = {
        lua = {
          require("formatter.filetypes.lua").stylua,
        },
        typescript = {
          require("formatter.filetypes.typescript").prettierd
        },
        javascript = {
          require("formatter.filetypes.javascript").prettierd
        },
        ["*"] = {
          require("formatter.filetypes.any").remove_trailing_whitespace
        }
      }
    }
  end
}
