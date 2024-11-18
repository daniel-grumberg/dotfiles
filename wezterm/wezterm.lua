-- Pull in the wezterm API
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- General appearence
config.color_scheme = 'catppuccin-mocha'
config.font = wezterm.font 'Iosevka Fixed'
config.font_size = 15
config.enable_scroll_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.initial_rows = 45
config.initial_cols = 140

-- Behaviors
config.quit_when_all_windows_are_closed = false
-- Mouse bindings
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'SUPER',
    mouse_reporting = true,
    action = wezterm.action.Nop,
  },
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'SUPER',
    mouse_reporting = true,
    action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor('Clipboard'),
  },
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'SUPER',
    mouse_reporting = false,
    action = wezterm.action.Nop,
  },
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'SUPER',
    mouse_reporting = false,
    action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor('Clipboard'),
  },
}

return config
