local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Your existing configuration
config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#CBE0F0",
	cursor_border = "#011423",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}

-- bumping up the refresh rate go brrrrr
config.max_fps = 120

config.font = wezterm.font("Hack Nerd Font")
config.font_size = 16
config.enable_tab_bar = false
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.6
config.macos_window_background_blur = 5

-- Toggle opacity function (your existing code)
wezterm.on("toggle-opacity", function(window)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 1.0
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

-- Toggle font size between current one and bigger size
wezterm.on("toggle-font-size", function(window)
	local overrides = window:get_config_overrides() or {}
	if not overrides.font_size then
		overrides.font_size = 24
	else
		overrides.font_size = nil
	end
	window:set_config_overrides(overrides)
end)

config.keys = {
	{
		key = "O",
		mods = "CTRL|SHIFT",
		action = wezterm.action.EmitEvent("toggle-opacity"),
	},
	{
		key = "+",
		mods = "CTRL|SHIFT",
		action = wezterm.action.EmitEvent("toggle-font-size"),
	},
}

-- Return the configuration to WezTerm
return config
