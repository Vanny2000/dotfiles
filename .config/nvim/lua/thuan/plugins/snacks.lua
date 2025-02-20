return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		image = {},
		indent = {},
		lazygit = {},
		picker = {
			sources = {
				explorer = {
					auto_close = true,
				},
			},
		},
		explorer = {},
		notifier = {},
		dashboard = {
			preset = {
				keys = {
					{
						icon = " ",
						key = "r",
						desc = "Recent Files",
						action = ":lua Snacks.dashboard.pick('oldfiles')",
					},
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
			desc = " Toggle file explorer",
		},
		{
			"<leader>ec",
			function()
				Snacks.dashboard.pick("files", { cwd = vim.fn.stdpath("config") })
			end,
			desc = " Explore config files",
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
		-- Diagnostics
		{
			"<leader>fds",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "[f]ind [d]iagnostic[s]",
		},
		{
			"<leader>fdc",
			function()
				Snacks.picker.diagnostics_buffer()
			end,
			desc = "[f]ind [d]iagnostic[s] in [c]urrent buffer",
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
	},
}
