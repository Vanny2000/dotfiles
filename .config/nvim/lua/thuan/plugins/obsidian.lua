return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	-- ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	event = {
		-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
		-- refer to `:h file-pattern` for more examples
		-- "BufReadPre path/to/my-vault/*.md",
		-- "BufNewFile path/to/my-vault/*.md",
		"BufReadPre "
			.. vim.fn.expand("~")
			.. "/Obsidian/The Brain/*.md",
		"BufNewFile " .. vim.fn.expand("~") .. "/Obsidian/The Brain/*.md",
	},
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",
		-- Optional
		"hrsh7th/nvim-cmp",
		"nvim-telescope/telescope.nvim",
		"nvim-treesitter",

		-- see below for full list of optional dependencies 👇
	},
	opts = {
		workspaces = {
			{
				name = "notes",
				path = "~/Obsidian/The Brain",
			},
		}, -- Optional, for templates (see below).
		templates = {
			folder = "Templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
			-- A map for custom variables, the key should be the variable and the value a function
			substitutions = {},
		},
		daily_notes = {
			-- Optional, if you keep daily notes in a separate directory.
			folder = "notes/dailies",
			-- Optional, if you want to change the date format for the ID of daily notes.
			date_format = "%Y-%m-%d",
			-- Optional, if you want to change the date format of the default alias of daily notes.
			alias_format = "%B %-d, %Y",
			-- Optional, default tags to add to each new daily note created.
			default_tags = { "daily-notes" },
			-- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
			template = nil,
		},
		completion = {
			-- Set to false to disable completion.
			nvim_cmp = true,
			-- Trigger completion at 2 chars.
			min_chars = 2,
		},
		-- ui = {
		-- 	enable = false,
		-- },

		-- see below for full list of options 👇
	},
	vim.keymap.set("n", "<leader>od", "<cmd>ObsidianDailies<CR>", { desc = "Open/Create daily notes" }),
	vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianNewFromTemplate<CR>", { desc = "Create new note from template" }),
	vim.keymap.set("v", "<leader>oe", "<cmd>ObsidianExtractNote<CR>", { desc = "Extact note" }),
	vim.keymap.set("n", "<leader>ow", "<cmd>ObsidianWorkspace<CR>", { desc = "Switch Workspaces" }),
	vim.keymap.set("n", "<leader>op", "<cmd>ObsidianPasteImg<CR>", { desc = "Paste image" }),
	vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "New note" }),
}
