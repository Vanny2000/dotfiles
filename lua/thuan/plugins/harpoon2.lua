return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	opts = {
		menu = {
			width = vim.api.nvim_win_get_width(0) - 4,
		},
		settings = {
			save_on_toggle = true,
		},
	},
	keys = function()
		local harpoon = require("harpoon")
		local keys = {
			{
				"<leader>a",
				function()
					harpoon:list():add()
				end,
				desc = "Harpoon Add file",
			},
			{
				"<leader>h",
				function()
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "Harpoon Quick Menu",
			},
			{
				"<leader>hc",
				function()
					harpoon:list():clear()
				end,
				desc = "Harpoon Clear",
			},
		}

		for i = 1, 3 do
			table.insert(keys, {
				"<leader>" .. i,
				function()
					harpoon:list():select(i)
				end,
				desc = "Harpoon to File " .. i,
			})
		end
		return keys
	end,
}
