return {
		"adibhanna/nvim-newfile.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("nvim-newfile").setup({
				templates = {
					php = {
						class = "<?php\n\nnamespace %s;\n\nfinal class %s\n{\n\t// TODO: Implement class\n}\n",
					},
				},
			})
			vim.keymap.set("n", "<leader>nf", ":NewFileHere<CR>", { desc = "Create new file here" })
		end,
	}
