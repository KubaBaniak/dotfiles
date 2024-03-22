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

    local augroup = vim.api.nvim_create_augroup
    local autocmd = vim.api.nvim_create_autocmd

    augroup("__formatter__", { clear = true })
    autocmd("BufWritePost", {
      group = "__formatter__",
      command = ":FormatWrite",
    })
  end
}
