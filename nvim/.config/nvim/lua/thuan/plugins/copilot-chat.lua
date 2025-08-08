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
		model = "claude-3.5-sonnet",
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
			EmailWriter = {
				prompt = "Write a professional email based on the following input.",
				system_prompt = [[
        You are a professional email writing assistant.
        Your job is to help craft clear, concise, and effective business emails that maintain a professional tone.

        Each email should include:
        - A clear and appropriate subject line
        - Professional greeting
        - Well-structured body with clear purpose
        - Appropriate closing
        - Professional signature (default: "Best regards, Thuan")

        Guidelines:
        - Use clear, concise language
        - Maintain a professional yet friendly tone
        - Ensure proper formatting and structure
        - Focus on clarity and actionable items
        - Adapt formality based on context provided
        - Avoid jargon unless specifically requested
        
        Use standard business email etiquette. Respond only based on the user's input.
        Always sign with "Best regards, Thuan" unless specified otherwise.
        ]],
				description = "Generate a professional email (input only)",
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
