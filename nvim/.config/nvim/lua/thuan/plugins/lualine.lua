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

		require("lualine").setup({
			options = {
				theme = "auto",
				-- component_separators = "",
				-- section_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
			},

			sections = {
				lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
        lualine_b = { {"filename", path = 0} },
				lualine_c = {
					"grapple",
          -- floaterm status
					{
						function()
							local status = _G.floaterm_status and _G.floaterm_status()
							if not status then
								return ""
							end
							return string.format("%s %d/%d", status.name, status.index, status.count)
						end,
						cond = function()
							return _G.floaterm_status and _G.floaterm_status() ~= nil
						end,
						color = { fg = "#1f1d2e", bg = "#ebbcba" },
						separator = { left = "", right = "" },
            padding = 1,
					},
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
