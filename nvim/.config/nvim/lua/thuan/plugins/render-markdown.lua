return {
	"MeanderingProgrammer/render-markdown.nvim",
	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
	-- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use standalone mini plugins
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		file_types = { "markdown", "md", "copilot-chat" },
		render_modes = { "n", "no", "c", "t", "i", "ic" },
		checkbox = {
			checked = { icon = "✔ " },
			custom = {
				in_progress = {
					raw = "[~]",
					rendered = "󰦖 ",
					highlight = "GruvboxPurpleSign",
				},
				blocked = {
					raw = "[!]",
					rendered = " ",
					highlight = "GruvboxRedSign",
				},
				whatever = {
					raw = "[>]",
					rendered = "󰆨 ",
					highlight = "GruvboxBg3",
				},
			},
		},
		callout = {
			-- Callouts are a special instance of a 'block_quote' that start with a 'shortcut_link'.
			-- The key is for healthcheck and to allow users to change its values, value type below.
			-- | raw        | matched against the raw text of a 'shortcut_link', case insensitive |
			-- | rendered   | replaces the 'raw' value when rendering                             |
			-- | highlight  | highlight for the 'rendered' text and quote markers                 |
			-- | quote_icon | optional override for quote.icon value for individual callout       |
			-- | category   | optional metadata useful for filtering                              |

			note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
			tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
			important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
			warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
			caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
			abstract = { raw = "[!ABSTRACT]", rendered = "󰨸 Abstract", highlight = "RenderMarkdownInfo" },
			summary = { raw = "[!SUMMARY]", rendered = "󰨸 Summary", highlight = "RenderMarkdownInfo" },
			tldr = { raw = "[!TLDR]", rendered = "󰨸 Tldr", highlight = "RenderMarkdownInfo" },
			info = { raw = "[!INFO]", rendered = "󰋽 Info", highlight = "RenderMarkdownInfo" },
			todo = { raw = "[!TODO]", rendered = "󰗡 Todo", highlight = "RenderMarkdownInfo" },
			hint = { raw = "[!HINT]", rendered = "󰌶 Hint", highlight = "RenderMarkdownSuccess" },
			success = { raw = "[!SUCCESS]", rendered = "󰄬 Success", highlight = "RenderMarkdownSuccess" },
			check = { raw = "[!CHECK]", rendered = "󰄬 Check", highlight = "RenderMarkdownSuccess" },
			done = { raw = "[!DONE]", rendered = "󰄬 Done", highlight = "RenderMarkdownSuccess" },
			question = { raw = "[!QUESTION]", rendered = "󰘥 Question", highlight = "RenderMarkdownWarn" },
			help = { raw = "[!HELP]", rendered = "󰘥 Help", highlight = "RenderMarkdownWarn" },
			faq = { raw = "[!FAQ]", rendered = "󰘥 Faq", highlight = "RenderMarkdownWarn" },
			attention = { raw = "[!ATTENTION]", rendered = "󰀪 Attention", highlight = "RenderMarkdownWarn" },
			failure = { raw = "[!FAILURE]", rendered = "󰅖 Failure", highlight = "RenderMarkdownError" },
			fail = { raw = "[!FAIL]", rendered = "󰅖 Fail", highlight = "RenderMarkdownError" },
			missing = { raw = "[!MISSING]", rendered = "󰅖 Missing", highlight = "RenderMarkdownError" },
			danger = { raw = "[!DANGER]", rendered = "󱐌 Danger", highlight = "RenderMarkdownError" },
			error = { raw = "[!ERROR]", rendered = "󱐌 Error", highlight = "RenderMarkdownError" },
			bug = { raw = "[!BUG]", rendered = "󰨰 Bug", highlight = "RenderMarkdownError" },
			example = { raw = "[!EXAMPLE]", rendered = "󰉹 Example", highlight = "RenderMarkdownHint" },
			quote = { raw = "[!QUOTE]", rendered = "󱆨 Quote", highlight = "RenderMarkdownQuote" },
			cite = { raw = "[!CITE]", rendered = "󱆨 Cite", highlight = "RenderMarkdownQuote" },
		},
		code = {
			sign = false,
			border = "thin",
			position = "right",
			width = "block",
			above = "▁",
			below = "▔",
			language_left = "█",
			language_right = "█",
			language_border = "▁",
			left_pad = 1,
			right_pad = 1,
		},
		heading = {
			width = "block",
			backgrounds = {
				"MiniStatusLineModeNormal",
				"MiniStatusLineModeInsert",
				"MiniStatusLineModeOther",
				"MiniStatusLineModeReplace",
				"MiniStatusLineModeCommand",
				"MiniStatusLineModeVisual",
			},
			sign = false,
			left_pad = 1,
			right_pad = 0,
			position = "right",
			icons = {
				"",
				"",
				"",
				"",
				"",
				"",
			},
			-- icons = {
			-- 	" ",
			-- 	" ",
			-- 	" ",
			-- 	" ",
			-- 	" ",
			-- 	" ",
			-- },
			-- icons = {
			-- 	"█ ",
			-- 	"██ ",
			-- 	"███ ",
			-- 	"████ ",
			-- 	"█████ ",
			-- 	"██████ ",
			-- },
		},
	},
}
