return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		image = {
			enable = true,
			doc = {
				enable = true,
				inline = false,
			},
		},
		input = {},
		indent = {},
		lazygit = {},
		dim = {},
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
		scroll = {
			duration = { step = 15, total = 200 },
			easing = "linear",
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
		{
			"<leader>en",
			function()
				local home = os.getenv("HOME")
				Snacks.dashboard.pick("files", { cwd = home .. "/Obsidian/The Brain/notes/dailies" })
			end,
			desc = "Explore daily notes",
		},
		{
			"<leader>bg",
			function()
				Snacks.picker.colorschemes()
			end,
			desc = "Explore colorschemes",
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
		-- Dim screen
		{
			"<leader>ds",
			function()
				Snacks.dim.enable()
			end,
			desc = "Dim screen",
		},
		{
			"<leader>dq",
			function()
				Snacks.dim.disable()
			end,
			desc = "Dim quit",
		},
	},
}
