return {
	"javiorfo/nvim-soil",
	dependencies = { "javiorfo/nvim-nyctophilia" },
	lazy = true,
	ft = "plantuml",
	config = function()
		-- Basic configurations
		local opts = {
			actions = {
				redraw = true,
			},
			puml_jar = "/opt/homebrew/Cellar/plantuml/1.2024.8/libexec/plantuml.jar",
			image = {
				darkmode = true,
				format = "png",
				execute_to_open = function(img)
					return "open " .. img
				end,
			},
		}

		-- Keymaps
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "plantuml",
			callback = function()
				-- Preview the diagram
				vim.keymap.set("n", "<leader>po", "<cmd>SoilOpenImg<cr>", {
					buffer = true,
					desc = "Preview PlantUML diagram",
				})

				-- Save and preview
				vim.keymap.set("n", "<leader>pp", "<cmd>Soil<cr>", {
					buffer = true,
					desc = "Save and preview PlantUML",
				})
			end,
		})

		require("soil").setup(opts)
	end,
}
