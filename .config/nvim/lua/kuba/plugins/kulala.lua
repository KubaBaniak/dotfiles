return {
  "mistweaverco/kulala.nvim",
  -- Load before session save/restore so VimLeavePre and SessionLoadPost hooks are registered.
  event = { "SessionLoadPost", "VimLeavePre" },
  keys = {
    {
      "<leader>Rs",
      function()
        require("kulala").run()
      end,
      ft = { "http", "rest" },
      desc = "Send request",
    },
    {
      "<leader>Ra",
      function()
        require("kulala").run_all()
      end,
      ft = { "http", "rest" },
      desc = "Send all requests",
    },
    {
      "<leader>Rb",
      function()
        require("kulala").scratchpad()
      end,
      desc = "Open scratchpad",
    },
    {
      "<leader>Rr",
      function()
        require("kulala").replay()
      end,
      ft = { "http", "rest" },
      desc = "Replay last request",
    },
    {
      "<leader>Rc",
      function()
        require("kulala").copy()
      end,
      ft = { "http", "rest" },
      desc = "Copy as cURL",
    },
    {
      "<leader>Ri",
      function()
        require("kulala").inspect()
      end,
      ft = { "http", "rest" },
      desc = "Inspect variables",
    },
    {
      "<leader>Re",
      function()
        require("kulala").set_selected_env()
      end,
      ft = { "http", "rest" },
      desc = "Select environment",
    },
    {
      "<leader>Rq",
      function()
        require("kulala").close()
      end,
      desc = "Close response window",
    },
  },
  ft = { "http", "rest", "javascript", "lua" },
  opts = {
    kulala_core = {
      path = nil,
      timeout = 60000,
      data_dir = nil,
      download_url = "https://github.com/mistweaverco/kulala-core/releases/download/%s/%s",
      download_tool = "curl",
    },
    session = {
      restore = true,
    },
    treesitter = {
      enable = true,
      cli_path = "tree-sitter",
    },
    -- dev, test, prod — matches *.env.json or http-client.env.json files
    -- see: https://learn.microsoft.com/en-us/aspnet/core/test/http-files?view=aspnetcore-8.0#environment-files
    default_env = "default",
    environment_scope = "b",
    vscode_rest_client_environmentvars = false,

    response_format = {
      indent = 2,
      expand_tabs = true,
      sort_keys = false,
    },
    ui = {
      display_mode = "split",
      split_direction = "right",
      win_opts = { bo = {}, wo = {} },
      default_view = "body",
      winbar = true,
      default_winbar_panes = { "body", "headers", "verbose", "script_output", "report" },
      winbar_labels = {
        body = "Body",
        headers = "Headers",
        headers_body = "All",
        verbose = "Verbose",
        script_output = "Script Output",
        stats = "Stats",
        report = "Report",
        help = "Help",
      },
      winbar_labels_keymaps = true,
      show_variable_info_text = false,
      show_icons = "on_request",
      icons = {
        inlay = {
          loading = "⏳",
          done = "✔",
          error = "✘",
        },
        lualine = "🐼",
        textHighlight = "WarningMsg",
        loadingHighlight = "Normal",
        doneHighlight = "String",
        errorHighlight = "ErrorMsg",
      },
      show_request_summary = true,
      max_response_size = 32768,
      max_request_size = 2048,
      report = {
        show_script_output = true,
        show_asserts_output = true,
        show_summary = true,
        headersHighlight = "Special",
        successHighlight = "String",
        errorHighlight = "Error",
      },
      scratchpad_default_contents = {
        "@MY_TOKEN_NAME=my_token_value",
        "",
        "# @name scratchpad",
        "POST https://echo.kulala.app/post HTTP/1.1",
        "accept: application/json",
        "content-type: application/json",
        "",
        "{",
        '  "foo": "bar"',
        "}",
      },
      pickers = {
        snacks = {
          layout = function()
            local has_snacks, snacks_picker = pcall(require, "snacks.picker")
            return not has_snacks and {}
              or vim.tbl_deep_extend("force", snacks_picker.config.layout("telescope"), {
                reverse = true,
                layout = {
                  { { win = "list" }, { height = 1, win = "input" }, box = "vertical" },
                  { win = "preview", width = 0.6 },
                  box = "horizontal",
                  width = 0.8,
                },
              })
          end,
        },
      },
    },

    lsp = {
      enable = true,
      filetypes = {
        "http",
        "rest",
        "javascript",
        "typescript",
        "lua",
      },
      enforce_external_script_naming_convention = true,
      keymaps = false,
      on_attach = nil,
    },

    debug = 3,
    generate_bug_report = false,

    -- Keymaps are defined above in the `keys` table (lazy-loaded, ft-scoped).
    global_keymaps = false,
    global_keymaps_prefix = "<leader>R",
    kulala_keymaps = true,
    kulala_keymaps_prefix = "",
  },
}
