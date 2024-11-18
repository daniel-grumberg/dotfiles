-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'catppuccin-mocha'

-- Font
config.font = wezterm.font 'Iosevka Fixed'
config.font_size = 15

-- General appearence
config.enable_scroll_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.initial_rows = 45
config.initial_cols = 140

-- and finally, return the configuration to wezterm
return config
