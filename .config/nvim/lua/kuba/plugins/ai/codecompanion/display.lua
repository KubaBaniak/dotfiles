return {
  chat = {
    intro_message = "Welcome to CodeCompanion ✨! Press ? for options",
    separator = "─",
    show_context = true,
    show_header_separator = false,
    show_settings = false,
    show_token_count = true,
    show_tools_processing = true,
    start_in_insert_mode = false,
    fold_reasoning = true,
    show_reasoning = true,
    window = {
      layout = "vertical",
      position = "right",
      width = 0.3,
      full_height = true,
      border = "single",
      opts = {
        breakindent = true,
        linebreak = true,
        wrap = true,
      },
    },
  },
  diff = {
    enabled = true,
    threshold_for_chat = 6,
    word_highlights = {
      additions = true,
      deletions = true,
    },
  },
  action_palette = {
    provider = "default",
    opts = {
      show_preset_actions = true,
      show_preset_prompts = true,
    },
  },
}
