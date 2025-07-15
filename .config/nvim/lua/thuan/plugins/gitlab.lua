return {
	"harrisoncramer/gitlab.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"stevearc/dressing.nvim", -- Recommended but not required. Better UI for pickers.
		"echasnovski/mini.icons", -- Recommended but not required. Icons in discussion tree.
	},
	build = function()
		require("gitlab.server").build(true)
	end, -- Builds the Go binary
	config = function()
		require("gitlab").setup()
	end,
}
