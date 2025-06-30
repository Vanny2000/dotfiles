return {
	"crnvl96/lazydocker.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	opts = {
		window = {
			settings = {
				width = 0.87, -- Percentage of screen width (0 to 1)
				height = 0.87, -- Percentage of screen height (0 to 1)
				border = "rounded", -- See ':h nvim_open_win' border options
				relative = "editor", -- See ':h nvim_open_win' relative options
			},
		},
	},
	keys = {
		{
			"<leader>ld",
			function()
				require("lazydocker").toggle()
			end,
			desc = "Open lazy docker",
		},
	},
}
