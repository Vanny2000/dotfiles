local full_name = os.getenv("USER") or "Unknown"

return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			question_header = " " .. full_name,
			answer_header = " ",
			error_header = "🚨",
			vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CopilotChat<CR>", {
				desc = "Open Copilot Chat",
			}),
		},
		-- See Commands section for default commands if you want to lazy load on them
	},
}
