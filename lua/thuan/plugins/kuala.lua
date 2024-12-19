return {
	"mistweaverco/kulala.nvim",
	opts = {
		icons = {
			inlay = {
				loading = "😴",
				done = "☺️",
				error = "😰",
			},
			lualine = "🐼",
		},
		show_icons = "above_request",
	},
	keys = function()
		local kulala = require("kulala")
		local keys = {
			{
				"<leader>rr",
				function()
					kulala.run()
				end,
				desc = "Run Current HTTP Request",
			},
			{
				"<leader>ra",
				function()
					kulala.run_all()
				end,
				desc = "Run All Requests in Buffer",
			},
			{
				"<leader>rp",
				function()
					kulala.replay()
				end,
				desc = "Replay Last Request",
			},
			{
				"<leader>ri",
				function()
					kulala.inspect()
				end,
				desc = "Inspect Request",
			},
			{
				"<leader>rc",
				function()
					kulala.copy()
				end,
				desc = "Copy Request as cURL",
			},
			{
				"<leader>rf",
				function()
					kulala.from_curl()
				end,
				desc = "Import cURL from Clipboard",
			},
			{
				"<leader>rt",
				function()
					kulala.toggle_view()
				end,
				desc = "Toggle Response View",
			},
			{
				"<leader>rx",
				function()
					kulala.close()
				end,
				desc = "Close current kulala",
			},
			{
				"<leader>rn",
				function()
					kulala.search()
				end,
				desc = "Search Named Requests",
			},
			{
				"<leader>rk",
				function()
					kulala.jump_prev()
					vim.cmd("normal! zz")
				end,
				desc = "Jump to Previous Request",
			},
			{
				"<leader>rj",
				function()
					kulala.jump_next()
					vim.cmd("normal! zz")
				end,
				desc = "Jump to Next Request",
			},
			{
				"<leader>re",
				function()
					kulala.get_selected_env()
				end,
				desc = "Get Selected Environment",
			},
			{
				"<leader>rE",
				function()
					kulala.set_selected_env()
				end,
				desc = "Set Environment",
			},
		}
		return keys
	end,
}
