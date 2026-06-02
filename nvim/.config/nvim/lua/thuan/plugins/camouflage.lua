return {
	"zeybek/camouflage.nvim",
	event = "VeryLazy",
	opts = {
		pwned = {
			enabled = false,
		},
		yank = {
			confirm = false,
			notify = false,
		},
		hooks = {
			on_before_decorate = function(_, filename)
				if not filename then
					return
				end
				local skip = { "%.example$", "%.sample$", "%.template$" }
				for _, pat in ipairs(skip) do
					if filename:match(pat) then
						return false
					end
				end
			end,
		},
	},
	keys = {
		{ "<leader>ct", "<cmd>CamouflageToggle<cr>", desc = "Toggle Camouflage" },
		{ "<leader>cr", "<cmd>CamouflageReveal<cr>", desc = "Reveal Line" },
		{ "<leader>cy", "<cmd>CamouflageYank<cr>", desc = "Yank Current env key" },
	},
}
