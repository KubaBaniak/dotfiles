-- Utilities for creating configurations
local util = require "formatter.util"

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  logging = false,
  log_level = vim.log.levels.WARN,
  filetype = {
    -- Formatter configurations for filetype "lua" go here
    -- and will be executed in order
    lua = {
      require("formatter.filetypes.lua").stylua,
    },
    c = {
      require("formatter.filetypes.c").clangformat,
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
