return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				background = {
					light = "latte",
					dark = "mocha",
				},
				transparent_background = true, -- Disable full transparency
				term_colors = true,
				on_colors = function(colors)
					colors.bg = "#1E1E2E"
					colors.fg = "#D9E0EE"
					colors.border = "#F5C2E7"
				end,
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					telescope = true,
					treesitter = true,
					-- Add other integrations as needed
				},
			})
			vim.cmd([[colorscheme catppuccin]])
		end,
	},
}
