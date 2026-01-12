return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        theme = "catppuccin-mocha",
      },
      sections = {
        lualine_a = {
          {
            "filename",
            file_status = true,
            newfile_status = false,
            path = 1,
          },
        },
      },
    })
  end,
}
