return {
	"adibhanna/nvim-newfile.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("nvim-newfile").setup({
			-- Optional configuration
		})
		vim.keymap.set("n", "<leader>nf", ":NewFileHere<CR>", { desc = "Create new file here" })
	end,
}
