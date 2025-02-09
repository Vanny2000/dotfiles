return {
	"tamton-aquib/duck.nvim",
	config = function()
		local duck = require("duck")
		vim.keymap.set("n", "<leader>dd", function()
			local chars = { ";", ")", "(", "[", "]", "{", "}" }
			for i = 1, #chars do
				duck.hatch(chars[i])
			end
		end, { desc = "Hatch duck with random semicolons and brackets" })
		vim.keymap.set("n", "<leader>da", function()
			duck.cook_all()
		end, { desc = "Cook all ducks" })
	end,
}
