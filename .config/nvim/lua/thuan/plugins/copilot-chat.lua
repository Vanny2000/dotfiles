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
		model = "claude-sonnet-4",
		auto_insert_mode = true,
		question_header = "  " .. user .. " ",
		answer_header = " ",
		error_header = "🚨",
		prompts = {
			JiraTicketWriter = {
				prompt = "Write a comprehensive Jira ticket based only on the following input.",
				system_prompt = [[
        You are a professional Jira ticket writer assisting software development teams. 
        Your job is to generate clear, complete, and structured Jira tickets that developers and QA engineers can act on immediately.

        Each ticket should include:
        - **Title**: A concise summary of the task or issue
        - **Description**: Background, context, goals, and rationale
        - **Acceptance Criteria**: Use checkboxes or Gherkin-style (Given/When/Then) for clarity
        - **Technical Notes** (optional): Constraints, edge cases, hints for implementation
        - **Attachments or Links** (optional): Diagrams, mocks, or relevant documentation

        Use plain, professional language. Ignore code or buffer context. Respond only based on the user's input.
        ]],
				description = "Generate a structured Jira ticket (input only)",
			},
		},
		-- Default chat mapping
		vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CopilotChat<CR>", {
			desc = "Open Copilot Chat (Context)",
		}),
		vim.keymap.set("n", "<leader>cs", ":CopilotChatSave ", { desc = "Save CopilotChat" }),
		vim.keymap.set("n", "<leader>cl", ":CopilotChatLoad ", { desc = "Load Copilot Chat" }),
	},
}
