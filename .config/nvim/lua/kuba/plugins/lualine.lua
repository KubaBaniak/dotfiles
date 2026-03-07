return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        theme = "catppuccin-mocha",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
      },
      tabline = {
        lualine_a = {
          {
            "buffers",
            show_filename_only = true,
            hide_filename_extension = false,
            show_modified_status = true,
            buffers_color = {
              active = "lualine_a_normal",
              inactive = "lualine_b_normal",
            },
          },
        },
        lualine_z = { "tabs" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          "diff",
          {
            "diagnostics",
            sources = { "nvim_lsp", "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = "󰝶 " },
          },
        },
        lualine_c = {
          {
            "filename",
            file_status = true,
            newfile_status = true,
            path = 1,
            symbols = {
              modified = " ●",
              readonly = " ",
              unnamed = "[No Name]",
              newfile = "[New]",
            },
          },
        },
        lualine_x = {
          {
            function()
              local clients = vim.lsp.get_clients({ bufnr = 0 })
              if #clients == 0 then
                return ""
              end
              local names = {}
              for _, c in ipairs(clients) do
                table.insert(names, c.name)
              end
              return " " .. table.concat(names, ", ")
            end,
            color = { fg = "#cba6f7" },
          },
          "encoding",
          "fileformat",
          "filetype",
        },
        lualine_y = { "selectioncount", "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_c = {
          {
            "filename",
            path = 1,
            symbols = { modified = " ●", readonly = " " },
          },
        },
        lualine_x = { "location" },
      },
    })
  end,
}
