local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- === LOGGING ===
-- Logi trafiają do: wezterm cli -> Help -> Show Log File
-- Lub: %USERPROFILE%/.local/share/wezterm/ (Windows)
wezterm.log_info('=== WezTerm config loaded at ' .. os.date('%Y-%m-%d %H:%M:%S') .. ' ===')

-- Log startup info for crash debugging
local ok, startup_info = pcall(function()
  wezterm.log_info('WezTerm version: ' .. wezterm.version)
  wezterm.log_info('Config dir: ' .. wezterm.config_dir)
  wezterm.log_info('OS: ' .. wezterm.target_triple)
  return true
end)
if not ok then
  wezterm.log_error('Failed to log startup info: ' .. tostring(startup_info))
end

-- Log config reload events
wezterm.on('window-config-reloaded', function(window, pane)
  wezterm.log_info('Config reloaded successfully')
end)

-- Log window/pane events for crash debugging
wezterm.on('window-focus-changed', function(window, pane)
  wezterm.log_info('Window focus changed, id=' .. tostring(window:window_id()))
end)

wezterm.on('pane-focus-changed', function(window, pane)
  local pane_info = pane:get_title()
  wezterm.log_info('Pane focus changed: ' .. tostring(pane_info))
end)

-- === APPEARANCE ===
config.color_scheme = 'Catppuccin Mocha (Gogh)'

-- Font (fixed: removed duplicate assignment)
config.font = wezterm.font_with_fallback({
  'IosevkaTerm Nerd Font',
  'Symbols Nerd Font',
  'Flog Symbols',
})
config.font_size = 12

-- Glyph rendering
config.custom_block_glyphs = true
config.allow_square_glyphs_to_overflow_width = 'WhenFollowedBySpace'
config.warn_about_missing_glyphs = false

-- Foreground brightness (reduced from 1.5 to 1.3 to avoid washing out)
config.foreground_text_hsb = {
  hue = 1.0,
  saturation = 1.2,
  brightness = 1.3,
}

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- === CURSOR ===
config.default_cursor_style = 'BlinkingBar'

-- === STABILITY SETTINGS ===
-- GPU frontend can cause crashes on some systems; try 'Software' if unstable
config.front_end = 'WebGpu'  -- alternatives: 'OpenGL', 'Software'
config.webgpu_power_preference = 'LowPower'

-- Scrollback (domyślnie 3500 — zwiększ jeśli potrzebujesz)
config.scrollback_lines = 10000

-- Limit max fps to reduce GPU pressure
config.max_fps = 60
config.animation_fps = 30

-- === KEYS ===
config.disable_default_key_bindings = true
config.keys = {
  -- Clipboard
  { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
  { key = 'C', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },
  -- Tabs
  { key = 'T', mods = 'CTRL|SHIFT', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'W', mods = 'CTRL|SHIFT', action = act.CloseCurrentTab { confirm = true } },
  { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
  -- Panes
  { key = '|', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '_', mods = 'CTRL|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  -- Font size
  { key = '+', mods = 'CTRL|SHIFT', action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = act.ResetFontSize },
  -- Debug: open debug overlay
  { key = 'L', mods = 'CTRL|SHIFT', action = act.ShowDebugOverlay },
}

-- === MOUSE ===
config.mouse_bindings = {
  {
    event = { Down = { streak = 3, button = 'Left' } },
    action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
    mods = 'NONE',
  },
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ""
      if has_selection then
        window:perform_action(act.CopyTo('ClipboardAndPrimarySelection'), pane)
        window:perform_action(act.ClearSelection, pane)
      else
        window:perform_action(act({ PasteFrom = 'Clipboard' }), pane)
      end
    end),
  },
}

-- === DOMAIN ===
config.default_domain = 'WSL:Ubuntu-24.04'

-- === BACKGROUND (uncomment to enable) ===
-- config.background = {
--   {
--     source = { File = { path = 'C:/Users/A100143/Pictures/bg.gif', speed = 0.2 } },
--     opacity = 1,
--     width = '100%',
--     hsb = { brightness = 0.5 },
--   },
-- }

wezterm.log_info('=== WezTerm config applied successfully ===')
return config
