return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		keymaps = {
			["q"] = { "actions.close", mode = "n" },
		},
		view_options = {
			show_hidden = true,
		},
		skip_confirm_for_simple_edits = true,
	},
	dependencies = { { "nvim-mini/mini.icons", opts = {} } },
	lazy = false,
	vim.keymap.set("n", "o", "<cmd>Oil<cr>", { desc = "Open oil" }),
}
