-- Parsers to keep installed. `query` is needed to edit .scm files,
-- `http` for kulala.nvim, `regex`/`markdown_inline` for injections.
local parsers = {
  "bash",
  "c",
  "css",
  "diff",
  "gitcommit",
  "git_rebase",
  "gitignore",
  "graphql",
  "html",
  "http",
  "javascript",
  "jsdoc",
  "json",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "query",
  "regex",
  "scss",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      -- On the `main` branch setup() only accepts install_dir.
      -- Highlighting/indentation are opt-in per buffer via vim.treesitter.start().
      require("nvim-treesitter").setup()

      -- install() is async and skips parsers that are already present.
      require("nvim-treesitter").install(parsers)

      -- Instead of hardcoding a filetype list, resolve the language for
      -- whatever filetype is opened and start treesitter if a parser exists.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("kuba_treesitter", { clear = true }),
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          if ft == "" or vim.bo[args.buf].buftype ~= "" then
            return
          end

          local lang = vim.treesitter.language.get_lang(ft)
          if not lang then
            return
          end

          -- Only start if the parser is actually installed. Note that in 0.12
          -- language.add() may RETURN false instead of raising, so check both.
          local ok, added = pcall(vim.treesitter.language.add, lang)
          if not ok or added == false then
            return
          end

          pcall(vim.treesitter.start, args.buf, lang)

          -- Tree-sitter indentation is still experimental; markdown has no
          -- indents query, so it keeps the runtime indentexpr.
          if ft ~= "markdown" then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- af/if (function), ac/ic (class), aa/ia (parameter) + ]f/[f navigation.
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          selection_modes = {
            ["@function.outer"] = "V",
            ["@class.outer"] = "V",
          },
        },
        move = { set_jumps = true },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      local textobjects = {
        ["af"] = { "@function.outer", "Function" },
        ["if"] = { "@function.inner", "Inner function" },
        ["ac"] = { "@class.outer", "Class" },
        ["ic"] = { "@class.inner", "Inner class" },
        ["aa"] = { "@parameter.outer", "Parameter" },
        ["ia"] = { "@parameter.inner", "Inner parameter" },
        ["ai"] = { "@conditional.outer", "Conditional" },
        ["ii"] = { "@conditional.inner", "Inner conditional" },
        ["al"] = { "@loop.outer", "Loop" },
        ["il"] = { "@loop.inner", "Inner loop" },
        ["a/"] = { "@comment.outer", "Comment" },
      }

      for lhs, spec in pairs(textobjects) do
        vim.keymap.set({ "x", "o" }, lhs, function()
          select.select_textobject(spec[1], "textobjects")
        end, { desc = "Select " .. spec[2] })
      end

      local moves = {
        ["]f"] = { move.goto_next_start, "@function.outer", "Next function" },
        ["]C"] = { move.goto_next_start, "@class.outer", "Next class" },
        ["]a"] = { move.goto_next_start, "@parameter.inner", "Next parameter" },
        ["[f"] = { move.goto_previous_start, "@function.outer", "Prev function" },
        ["[C"] = { move.goto_previous_start, "@class.outer", "Prev class" },
        ["[a"] = { move.goto_previous_start, "@parameter.inner", "Prev parameter" },
        ["]F"] = { move.goto_next_end, "@function.outer", "Next function end" },
        ["[F"] = { move.goto_previous_end, "@function.outer", "Prev function end" },
      }

      for lhs, spec in pairs(moves) do
        vim.keymap.set({ "n", "x", "o" }, lhs, function()
          spec[1](spec[2], "textobjects")
        end, { desc = spec[3] })
      end
    end,
  },

  -- Auto close / rename JSX and HTML tags.
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    },
  },
}
