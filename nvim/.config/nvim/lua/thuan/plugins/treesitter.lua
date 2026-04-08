return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"html",
				"css",
				"prisma",
				"markdown",
				"markdown_inline",
				"svelte",
				"graphql",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"vimdoc",
				"c",
				"php",
				"python",
				"http",
				"vue",
				"go",
				"blade",
			}

			-- Only install parsers that are missing (avoids reinstall on every startup)
			local already_installed = require("nvim-treesitter.config").get_installed("parsers")
			local to_install = vim.iter(ensure_installed)
				:filter(function(p)
					return not vim.tbl_contains(already_installed, p)
				end)
				:totable()
			if #to_install > 0 then
				require("nvim-treesitter").install(to_install)
			end

			-- Filetypes that should get treesitter highlight / fold / indent.
			-- These map to the parsers above (note: tsx -> typescriptreact, vimdoc -> help, etc.)
			local filetypes = {
				"json",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"yaml",
				"html",
				"css",
				"prisma",
				"markdown",
				"svelte",
				"graphql",
				"bash",
				"sh",
				"zsh",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"help",
				"c",
				"php",
				"python",
				"http",
				"vue",
				"go",
				"blade",
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = filetypes,
				callback = function()
					-- syntax highlighting (Neovim core)
					pcall(vim.treesitter.start)
					-- folds (Neovim core)
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.wo.foldmethod = "expr"
					-- indentation (nvim-treesitter)
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
}
