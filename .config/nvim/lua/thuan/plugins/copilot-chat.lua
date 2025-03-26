local user = vim.env.USER or "User"
user = user:sub(1, 1):upper() .. user:sub(2)

return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			model = "claude-3.7-sonnet",
			auto_insert_mode = true,
			question_header = "  " .. user .. " ",
			answer_header = " ",
			error_header = "🚨",
			vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CopilotChat<CR>", {
				desc = "Open Copilot Chat",
			}),
		},

		-- See Commands section for default commands if you want to lazy load on them
	},
}
