return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		image = {},
		indent = {},
		lazygit = {},
		picker = {},
		explorer = {},
		notifier = {},
		dim = {},
		dashboard = {
			preset = {
				keys = {
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
					},
					{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
				header = [[
  ██╗  ██╗██████╗ ███████╗██╗██████╗ ███████╗
  ██║ ██╔╝██╔══██╗██╔════╝██║██╔══██╗██╔════╝
  █████╔╝ ██████╔╝█████╗  ██║██║  ██║███████╗
  ██╔═██╗ ██╔══██╗██╔══╝  ██║██║  ██║╚════██║
  ██║  ██╗██║  ██║███████╗██║██████╔╝███████║
  ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═════╝ ╚══════╝
        ]],
			},
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{ section = "startup" },
			},
		},
	},
	keys = {
		-- Lazygit
		{
			"<leader>lg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		-- File Explorer
		{
			"<leader>ee",
			function()
				Snacks.explorer()
			end,
			desc = "Toggle file explorer",
		},
		-- Searching
		{
			"<leader>ff",
			function()
				Snacks.picker.files()
			end,
			desc = "Fuzzy find files in cwd",
		},
		{
			"<leader>fc",
			function()
				Snacks.picker.grep_word()
			end,
			desc = "Fuzzy find word undercusor in cwd",
		},
		{
			"<leader>fs",
			function()
				Snacks.picker.grep()
			end,
			desc = "Fuzzy find word in cwd",
		},
		-- Notifier
		{
			"<leader>nn",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Show notification history",
		},
		{
			"<leader>nd",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Dismiss notification",
		},
		-- Dim screen
		{
			"<leader>ds",
			function()
				Snacks.dim.enable()
			end,
			desc = "Dim screen",
		},
		{
			"<leader>dd",
			function()
				Snacks.dim.disable()
			end,
			desc = "Disable Dim screen",
		},
	},
}
