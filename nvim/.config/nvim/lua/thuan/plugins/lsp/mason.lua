return {
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			-- list of servers for mason to install
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"prismals",
				"pyright",
				"eslint",
				"intelephense",
				"gopls",
				"astro",
			},
		},
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
			"neovim/nvim-lspconfig",
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				"biome", -- js/ts/json formatter + linter
				"prettier", -- fallback formatter (md/css/html/etc.)
				"eslint_d", -- js/ts linter daemon
				"stylua", -- lua formatter
				"black", -- python formatter
				"ruff", -- python formatter + linter
				"pylint", -- python linter
				"pint", -- php/laravel formatter
				"blade-formatter", -- php/laravel blade formatter
				"taplo", -- toml formatter
				"goimports", -- go formatter
				"delve", -- go debugger
			},
		},
		dependencies = {
			"williamboman/mason.nvim",
		},
	},
}
