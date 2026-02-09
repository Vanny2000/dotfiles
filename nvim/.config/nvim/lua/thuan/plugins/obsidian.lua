return {
	"obsidian-nvim/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	-- 	-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	-- 	-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
	-- 	-- refer to `:h file-pattern` for more examples
	-- 	-- "BufReadPre path/to/my-vault/*.md",
	-- 	-- "BufNewFile path/to/my-vault/*.md",
	-- 	"BufReadPre "
	-- 		.. vim.fn.expand("~")
	-- 		.. "/Obsidian/The Brain/*.md",
	-- 	"BufNewFile " .. vim.fn.expand("~") .. "/Obsidian/The Brain/*.md",
	-- },
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",
		-- Optional
		"hrsh7th/nvim-cmp",
		"nvim-treesitter",

		-- see below for full list of optional dependencies 👇
	},
	opts = {
		picker = {
			-- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', 'mini.pick' or 'snacks.pick'.
			name = "snacks.pick",
		},
		workspaces = {
			{
				name = "notes",
				path = "~/Obsidian/The Brain",
			},
		},
		-- Optional, for templates (see below).
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
		-- Specify how to handle attachments.
		attachments = {
			-- The default folder to place images in via `:ObsidianPasteImg`.
			-- If this is a relative path it will be interpreted as relative to the vault root.
			-- You can always override this per image by passing a full path to the command instead of just a filename.
			folder = "assets/imgs", -- This is the default

			-- Optional, customize the default name or prefix when pasting images via `:ObsidianPasteImg`.
			---@return string
			img_name_func = function()
				-- Prefix image names with timestamp.
				return string.format("%s-", os.time())
			end,

			-- A function that determines the text to insert in the note when pasting an image.
			-- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
			-- This is the default implementation.
			---@param client obsidian.Client
			---@param path obsidian.Path the absolute path to the image file
			---@return string
			img_text_func = function(client, path)
				path = client:vault_relative_path(path) or path
				return string.format("![%s](%s)", path.name, path)
			end,
		},
		ui = {
			enable = false,
		},

		-- see below for full list of options 👇
    legacy_command = false,
	},
}
