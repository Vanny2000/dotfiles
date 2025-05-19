local user = vim.env.USER or "User"
user = user:sub(1, 1):upper() .. user:sub(2)

return {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
		{ "nvim-lua/plenary.nvim", branch = "master" },
	},
	build = "make tiktoken",
	opts = {
		model = "gemini-2.5-pro",
		auto_insert_mode = true,
		question_header = "  " .. user .. " ",
		answer_header = " ",
		error_header = "🚨",
		-- Default chat mapping
		vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CopilotChat<CR>", {
			desc = "Open Copilot Chat (Context)",
		}),
	},
}
