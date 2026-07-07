return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  opts = function()
    local ok, themes = pcall(require, "telescope.themes")

    return {
      input = {
        relative = "editor",
        prefer_width = 0.5,
        min_width = { 60, 0.4 },
        max_width = { 160, 0.9 },
      },
      select = {
        telescope = ok and themes.get_dropdown({
          layout_config = {
            width = 0.8,
            height = 0.5,
          },
        }) or nil,
        builtin = {
          min_width = { 60, 0.4 },
          max_width = { 160, 0.9 },
        },
      },
    }
  end,
}
