return {
	"mistweaverco/kulala.nvim",
	ft = { "http", "rest" },
	opts = {
		global_keymaps = false,
		global_keymaps_prefix = "<leader>R",
		kulala_keymaps_prefix = "",
		-- icons position: "signcolumn"|"on_request"|"above_request"|"below_request" or nil to disable
		show_icons = "signcolumn",
		-- default icons
		icons = {
			inlay = {
				loading = "󱇝 ",
				done = "󰏚 ",
				error = " ",
			},
			lualine = "🐼",
			textHighlight = "WarningMsg", -- highlight group for request elapsed time
		},
		lsp = {
			enable = true,
			formatter = true,
		},
	},
}
