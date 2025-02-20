return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		{
			"L3MON4D3/LuaSnip",
			-- follow latest release.
			version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
			-- install jsregexp (optional!).
			build = "make install_jsregexp",
		},
		{
			"mistweaverco/kulala-cmp-graphql.nvim", -- GraphQL source for nvim-cmp in http files
			opts = {},
			ft = "http",
		},
		"saadparwaiz1/cmp_luasnip", -- for autocompletion
		"rafamadriz/friendly-snippets", -- useful snippets
		"onsails/lspkind.nvim", -- vs-code like pictograms
	},
	config = function()
		local cmp = require("cmp")

		local luasnip = require("luasnip")

		local lspkind = require("lspkind")

		-- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
		require("luasnip.loaders.from_vscode").lazy_load()
		require("luasnip").filetype_extend("php", { "html" })
		require("luasnip").filetype_extend("php", { "phpdoc" })
		require("luasnip").filetype_extend("php", { "blade" })
		require("luasnip").filetype_extend("vue", { "html" })
		cmp.setup({
			completion = {
				completeopt = "menu,menuone,preview,noselect",
			},
			snippet = { -- configure how nvim-cmp interacts with snippet engine
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
				["<Tab>"] = cmp.mapping.confirm({ select = true }),
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
			}),
			-- sources for autocompletion
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- snippets
				{ name = "buffer" }, -- text within current buffer
				{ name = "path" }, -- file system paths
			}),

			-- configure lspkind for vs-code like pictograms in completion menu
			---@diagnostic disable-next-line: missing-fields
			formatting = {
				format = function(entry, item)
					local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })
					item = lspkind.cmp_format({
						-- any lspkind format settings here
						maxwidth = 50,
						ellipsis_char = "...",
					})(entry, item)
					if color_item.abbr_hl_group then
						item.kind_hl_group = color_item.abbr_hl_group
						item.kind = color_item.abbr
					end
					return item
				end,
			},
		})
		cmp.setup.filetype("http", {
			sources = cmp.config.sources({
				{ name = "kulala-cmp-graphql" },
				{ name = "luasnip" }, -- snippets
			}, {
				{ name = "buffer" },
			}),
		})
	end,
}
