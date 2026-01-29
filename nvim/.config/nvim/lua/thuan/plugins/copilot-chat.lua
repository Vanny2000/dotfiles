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
		model = "grok-code-fast-1",
		auto_insert_mode = true,
    headers = {
      user = "  " .. user .. " ",
      assistant = " ",
    },
		error_header = "🚨",
		prompts = {
			JiraTicketWriter = {
				prompt = "Write a comprehensive Jira ticket based only on the following input.",
				system_prompt = [[
        You are a professional Jira ticket writer assisting software development teams. 
        Your job is to generate clear, complete, and structured Jira tickets that developers and QA engineers can act on immediately.
        Write the ticket base on the context provided and your understanding of best practices, do not ask to see more files or information.

        Each ticket should include:
        - **Title**: A concise summary of the task or issue
        - **Description**: Background, context, goals, and rationale
        - **Acceptance Criteria**: Use Gherkin-style (Given/When/Then) for clarity

        Use plain, professional language. Ignore code or buffer context. Respond only based on the user's input.
        ]],
				description = "Generate a structured Jira ticket",
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
			MessageWriter = {
				prompt = "Write a professional message based on the following input.",
				system_prompt = [[
        You are a professional message writing assistant.
        Your job is to help craft clear, concise, and effective messages for various platforms (e.g., Slack, Teams, SMS) that maintain a professional tone.

        Each message should include:
        - A clear and appropriate greeting
        - Well-structured body with clear purpose
        - Appropriate closing (if needed)
        
        Guidelines:
        - Use clear, concise language
        - Maintain a professional yet friendly tone
        - Ensure proper formatting and structure
        - Focus on clarity and actionable items
        - Adapt formality based on context provided
        - Avoid jargon unless specifically requested
        
        Use standard business messaging etiquette. Respond only based on the user's input.
        Always sign with "Best regards, Thuan" unless specified otherwise.
        ]],
				description = "Generate a professional message (input only)",
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
