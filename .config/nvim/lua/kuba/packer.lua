-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
  -- Packer can manage itself
  use("wbthomason/packer.nvim")

  -- TELESCOPE
  use({
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    -- or, branch = '0.1.x',
    requires = { { "nvim-lua/plenary.nvim" } },
  })
  -- THEMES
  use({ "catppuccin/nvim", as = "catppuccin" })
  use("shaunsingh/nord.nvim")
  use({
    "mcchrish/zenbones.nvim",
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    requires = "rktjmp/lush.nvim",
  })

  -- UNDOTREE
  use("mbbill/undotree")
  -- TREESITTER
  use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
  -- LSP
  use({
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    requires = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },

      -- LSP Support
      { "neovim/nvim-lspconfig" },
      -- Autocompletion
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "L3MON4D3/LuaSnip" },
    },
  })
  --FORMATING
  use { 'mhartington/formatter.nvim' }
  --LINTING
  use { 'mfussenegger/nvim-lint' }
  -- LUALINE (BOTTOM LINE)
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
  })
  -- LATEX/ SNIPPETS
  use("lervag/vimtex")

  --use {
  --  "iurimateus/luasnip-latex-snippets.nvim",
  --  -- replace "lervag/vimtex" with "nvim-treesitter/nvim-treesitter" if you're
  --  -- using treesitter.
  --  requires = { "L3MON4D3/LuaSnip", "nvim-treesitter/nvim-treesitter" },
  --  config = function()
  --    require'luasnip-latex-snippets'.setup({ use_treesitter = true })
  --  end,
  --  -- treesitter is required for markdown
  --  ft = { "tex", "markdown" },
  --}

  -- TOGGLETERM
  use({
    "akinsho/toggleterm.nvim",
    tag = "*",
    config = function()
      require("toggleterm").setup()
    end,
  })

  -- Autopairs
  use({
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  })
  -- Unless you are still migrating, remove the deprecated commands from v1.x
  vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

  -- Icons for neotree
  use("nvim-tree/nvim-web-devicons") -- not strictly required, but recommended
  -- Neotree
  use({
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim",              -- Optional image support in preview window: See `# Preview Mode` for more information
      {
        "s1n7ax/nvim-window-picker",
        version = "2.*",
        config = function()
          require("window-picker").setup({
            filter_rules = {
              include_current_win = false,
              autoselect_one = true,
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { "neo-tree", "neo-tree-popup", "notify" },
                -- if the buffer type is one of following, the window will be ignored
                buftype = { "terminal", "quickfix" },
              },
            },
          })
        end,
      },
    },
    config = function()
      -- If you want icons for diagnostic errors, you'll need to define them somewhere:
      vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
      vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
      vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

      vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
    end,
  })
  -- Github
  use({
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim",        -- optional
    },
    config = true,
  })

  use("christoomey/vim-tmux-navigator")
end)
