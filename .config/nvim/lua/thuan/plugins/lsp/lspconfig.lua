return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		-- import cmp-nvim-lsp plugin for capabilities
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>lua Snacks.picker.lsp_references()<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>lua Snacks.picker.lsp_definitions()<CR>zz", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>lua Snacks.picker.lsp_implementations()<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>lua Snacks.picker.lsp_type_definitions()<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>ren", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>lua Snacks.picker.diagnostics({ buf = 0 })<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				-- opts.desc = "Go to previous diagnostic"
				-- keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
				--
				-- opts.desc = "Go to next diagnostic"
				-- keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Configure individual servers using vim.lsp.config
		vim.lsp.config("vue_ls", {
			capabilities = capabilities,
			filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			init_options = {
				vue = {
					hybridMode = false,
				},
				typescript = {
					tsdk = "/Users/thuan/.local/share/nvim/mason/packages/vue-language-server/node_modules/typescript/lib",
				},
			},
			on_attach = function(client, _)
				if client.name == "vue_ls" then
					client.server_capabilities.documentFormattingProvider = false
				end
			end,
		})

		vim.lsp.config("intelephense", {
			capabilities = capabilities,
			settings = {
				intelephense = {
					format = {
						enable = true, -- Enable formatting
					},
					files = {
						maxSize = 5000000, -- Increase the file size limit if necessary
					},
					diagnostics = {
						enable = true,
					},
				},
			},
		})

		vim.lsp.config("svelte", {
			capabilities = capabilities,
			on_attach = function(client, _)
				vim.api.nvim_create_autocmd("BufWritePost", {
					pattern = { "*.js", "*.ts" },
					callback = function(ctx)
						-- Here use ctx.match instead of ctx.file
						client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
					end,
				})
			end,
		})

		vim.lsp.config("graphql", {
			capabilities = capabilities,
			filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
		})

		vim.lsp.config("emmet_ls", {
			capabilities = capabilities,
			filetypes = {
				"html",
				"typescriptreact",
				"javascriptreact",
				"css",
				"sass",
				"scss",
				"less",
				"svelte",
			},
		})

		vim.lsp.config("cssls", {
			capabilities = capabilities,
			settings = {
				css = {
					lint = {
						unknownAtRules = "ignore",
					},
				},
			},
		})

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					-- make the language server recognize "vim" global
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		})
		vim.diagnostic.config({
			-- Change the Diagnostic symbols in the sign column (gutter)
			signs = {
				active = true,
				text = {
					-- [vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.HINT] = "󰟃",
					[vim.diagnostic.severity.INFO] = "",
				},
			},
			-- Use the default configuration
			-- virtual_lines = true

			-- Alternatively, customize specific options
			virtual_lines = {
				-- Only show virtual line diagnostics for the current cursor line
				current_line = true,
			},
		})

		-- Enable LSP servers using vim.lsp.enable (Neovim 0.11+)
		vim.lsp.enable("lua_ls")
		vim.lsp.enable("vue_ls")
		vim.lsp.enable("intelephense")
		vim.lsp.enable("svelte")
		vim.lsp.enable("graphql")
		vim.lsp.enable("emmet_ls")
		vim.lsp.enable("cssls")
	end,
}
