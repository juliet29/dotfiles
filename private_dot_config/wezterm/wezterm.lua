local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

-- Font (matching kitty)
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 12.0

-- actually, do want tabs and to be able to close windows with buttons
config.enable_tab_bar = true -- set to false for tmux..
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"

config.window_background_opacity = 0.8
config.macos_window_background_blur = 10

-- ayu-dark (matches tmux-dotbar defaults so the status bar blends in)
config.color_scheme = "Ayu Mirage (Gogh)"

-- keys.. although tmux may override
config.keys = {
	-- Split panes
	{ key = "v", mods = "CTRL|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "s", mods = "CTRL|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- Tabs
	{ key = "t", mods = "CTRL|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "q", mods = "CTRL|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "w", mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = true }) },

	-- Navigate between panes
	{ key = "}", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Next") },
	{ key = "{", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Prev") },

	-- Navigate between tabs
	{ key = "RightArrow", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(1) },
	{ key = "LeftArrow", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
}

return config
