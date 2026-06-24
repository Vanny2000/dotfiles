return {
	"christoomey/vim-tmux-navigator",
	-- Don't let the plugin create its own mappings. Its built-in terminal-mode
	-- mappings are written for Vim (they use <C-w> to leave terminal mode, which
	-- does nothing in Neovim) so they leak "TmuxNavigateDown" into the shell, and
	-- they clobber the floating-terminal <C-j>/<C-k> maps in plugin/floaterm.lua.
	-- The normal-mode nav we want is defined via `keys` below.
	init = function()
		vim.g.tmux_navigator_no_mappings = 1
	end,
	cmd = {
		"TmuxNavigateLeft",
		"TmuxNavigateDown",
		"TmuxNavigateUp",
		"TmuxNavigateRight",
		"TmuxNavigatePrevious",
		"TmuxNavigatorProcessList",
	},
	keys = {
		{ "<c-h>", "<cmd>TmuxNavigateLeft<cr>" },
		{ "<c-j>", "<cmd>TmuxNavigateDown<cr>" },
		{ "<c-k>", "<cmd>TmuxNavigateUp<cr>" },
		{ "<c-l>", "<cmd>TmuxNavigateRight<cr>" },
		{ "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
	},
}
