return {
	"monkoose/neocodeium",
	event = "VeryLazy",
	config = function()
		local neocodeium = require("neocodeium")
		neocodeium.setup()
		vim.keymap.set("i", "<C-f>", function()
			neocodeium.accept()
		end, { desc = "Accept completion" })
		vim.keymap.set("i", "<C-w>", function()
			neocodeium.accept_word()
		end, { desc = "Accept word completion" })
		vim.keymap.set("i", "<C-a>", function()
			neocodeium.accept_line()
		end, { desc = "Accept line completion" })
		vim.keymap.set("i", "<C-e>", function()
			neocodeium.cycle_or_complete()
		end, { desc = "Cycle or complete" })
		vim.keymap.set("i", "<C-c>", function()
			neocodeium.clear()
		end, { desc = "Clear suggestions" })
	end,
}
