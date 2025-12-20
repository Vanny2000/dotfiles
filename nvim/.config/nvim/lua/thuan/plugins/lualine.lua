return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- Gruvbox Dark Hard colors
		local colors = {
			bg0_hard = "#1d2021",
			bg0 = "#282828",
			bg1 = "#3c3836",
			bg2 = "#504945",
			fg0 = "#fbf1c7",
			fg1 = "#ebdbb2",
			red = "#fb4934",
			green = "#b8bb26",
			yellow = "#fabd2f",
			blue = "#83a598",
			purple = "#d3869b",
			aqua = "#8ec07c",
			orange = "#fe8019",
			gray = "#928374",
		}

		local bubbles_theme = {
			normal = {
				a = { fg = colors.bg0_hard, bg = colors.blue, gui = "bold" },
				b = { fg = colors.fg1, bg = colors.bg2 },
				c = { fg = colors.fg1, bg = colors.bg0_hard },
			},

			insert = { a = { fg = colors.bg0_hard, bg = colors.green, gui = "bold" } },
			visual = { a = { fg = colors.bg0_hard, bg = colors.orange, gui = "bold" } },
			replace = { a = { fg = colors.bg0_hard, bg = colors.red, gui = "bold" } },
			command = { a = { fg = colors.bg0_hard, bg = colors.yellow, gui = "bold" } },

			inactive = {
				a = { fg = colors.gray, bg = colors.bg1 },
				b = { fg = colors.gray, bg = colors.bg1 },
				c = { fg = colors.gray, bg = colors.bg0_hard },
			},
		}

		local function get_tmux_window()
			local handle = io.popen("tmux display-message -p '#W'")
			---@diagnostic disable-next-line: need-check-nil
			local result = handle:read("*a")
			---@diagnostic disable-next-line: need-check-nil
			handle:close()
			return result:gsub("\n", "") -- Remove any trailing newline
		end

		require("lualine").setup({
			options = {
				theme = "auto",
				-- component_separators = "",
				-- section_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { 'AgenticChat', 'AgenticInput', 'AgenticCode', 'AgenticFiles' },
          winbar = { 'AgenticChat', 'AgenticInput', 'AgenticCode', 'AgenticFiles' },
        }
			},

			sections = {
				lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
				lualine_b = { "filename" },
				lualine_c = {
					{ get_tmux_window, icon = "" }, -- Add the tmux window component
					"grapple",
				},
				lualine_x = {
					{

						require("noice").api.statusline.mode.get,

						cond = require("noice").api.statusline.mode.has,

						color = { fg = "#ff9e64" },
					},
				},
				lualine_y = {
					"filetype",
					"progress",
				},
				lualine_z = {
					{
						function()
							return " " .. os.date("%R")
						end,
						separator = { right = "" },
					},
				},
			},
			inactive_sections = {
				lualine_a = { "filename" },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = { "location" },
			},
			tabline = {},
			extensions = {},
		})
	end,
}
