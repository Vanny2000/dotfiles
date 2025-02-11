return {
	"github/copilot.vim",
	dependencies = { "catppuccin/nvim" },
	event = "VimEnter",
	config = function()
		vim.keymap.set("i", "<C-f>", 'copilot#Accept("\\<CR>")', {
			expr = true,
			replace_keycodes = false,
		})
		vim.g.copilot_no_tab_map = true
		vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
	end,
	keys = {},
}
