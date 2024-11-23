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

-- Launch tmux by default in a "scratch session"
-- To do this we grab the user's shell by querying the environment and launching it as a login shell dropping into tmux,
-- then if tmux exits (it very well might not), then we immediately launch an iterative shell.
-- This is unfortunately kind of hacky but oh well...
config.default_prog = { os.getenv('SHELL'), '--login', '-c', 'tmux new-session -A -s scratch; $SHELL' }

-- Finally return the config
return config
