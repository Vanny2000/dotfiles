return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-neotest/nvim-nio",
		"leoluz/nvim-dap-go",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local dap_go = require("dap-go")

		-- PHP / Xdebug configuration
		dap.adapters.php = {
			type = "executable",
			command = "node",
			args = { os.getenv("HOME") .. "/vscode-php-debug/out/phpDebug.js" },
		}

		dap.configurations.php = {
			{
				type = "php",
				request = "launch",
				name = "Listen for Xdebug",
				port = 9003,
			},
		}
		-- Go Debugging Configuration
		dap.adapters.go = {
			type = "executable",
			command = "dlv",
			args = { "dap", "-l", "127.0.0.1:${port}" },
		}

		-- Go debug configurations
		dap.configurations.go = {
			{
				type = "go",
				name = "Debug",
				request = "launch",
				program = "${file}",
			},
			{
				type = "go",
				name = "Debug test", -- configuration for debugging test files
				request = "launch",
				mode = "test",
				program = "${file}",
			},
			{
				type = "go",
				name = "Debug test (go.mod)",
				request = "launch",
				mode = "test",
				program = "./${relativeFileDirname}",
			},
		}
		-- Setup dap-go
		dap_go.setup({
			-- Additional configuration for dap-go
			dap_configurations = {
				{
					-- Extra configuration for remote debugging
					type = "go",
					name = "Remote Debug",
					request = "attach",
					mode = "remote",
					connect = {
						host = "127.0.0.1",
						port = "2345",
					},
				},
			},
			-- Delve configurations
			delve = {
				initialize_timeout_sec = 20,
				port = 2345,
				args = {},
			},
		})

		-- DAP UI setup
		dapui.setup({
			controls = {
				element = "repl",
				enabled = true,
				icons = {
					disconnect = "",
					pause = "",
					play = "",
					run_last = "",
					step_back = "",
					step_into = "",
					step_out = "",
					step_over = "",
					terminate = "",
				},
			},
			element_mappings = {},
			expand_lines = true,
			floating = {
				border = "single",
				mappings = {
					close = { "q", "<Esc>" },
				},
			},
			force_buffers = true,
			icons = {
				collapsed = "",
				current_frame = "",
				expanded = "",
			},
			layouts = {
				{
					elements = {
						{
							id = "scopes",
							size = 0.5,
						},
						{
							id = "breakpoints",
							size = 0.25,
						},
						-- {
						-- 	id = "stacks",
						-- 	size = 0.25,
						-- },
						-- {
						-- 	id = "watches",
						-- 	size = 0.25,
						-- },
					},
					position = "left",
					size = 40,
				},
				{
					elements = {
						{
							id = "repl",
							size = 1,
						},
						-- {
						-- 	id = "console",
						-- 	size = 0.5,
						-- },
					},
					position = "bottom",
					size = 10,
				},
			},
			mappings = {
				edit = "e",
				expand = { "<CR>", "<2-LeftMouse>" },
				open = "o",
				remove = "d",
				repl = "r",
				toggle = "t",
			},
			render = {
				indent = 1,
				max_value_lines = 100,
			},
		})

		-- Auto-open UI when debugging starts
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end

		-- Debugging keymaps
		local keymap = vim.keymap
		local opts = { silent = true }

		-- Debug mode prefix key
		local debug_prefix = "<leader>d"

		-- Basic controls
		keymap.set("n", debug_prefix .. "n", "<cmd>DapNew<CR>", { desc = "Launch new debug session", unpack(opts) })
		keymap.set("n", debug_prefix .. "c", dap.continue, { desc = "Continue", unpack(opts) })
		-- Stepping
		keymap.set("n", "<leader><leader>", dap.step_over, { desc = "Step Over", unpack(opts) })
		keymap.set("n", debug_prefix .. "i", dap.step_into, { desc = "Step Into", unpack(opts) })
		keymap.set("n", debug_prefix .. "O", dap.step_out, { desc = "Step Out", unpack(opts) })

		-- Breakpoints
		keymap.set("n", debug_prefix .. "b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint", unpack(opts) })
		keymap.set("n", debug_prefix .. "B", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Set Conditional Breakpoint", unpack(opts) })

		-- UI Controls
		keymap.set("n", debug_prefix .. "u", dapui.toggle, { desc = "Toggle UI", unpack(opts) })

		-- Reset/Clear all
		keymap.set("n", debug_prefix .. "r", function()
			dap.clear_breakpoints()
			dapui.close()
			dap.terminate()
		end, { desc = "Reset Debug Session", unpack(opts) })

		-- Restart session without clearing breakpoints
		keymap.set(
			"n",
			debug_prefix .. "x",
			dap.restart,
			{ desc = "Reset Debug Session w/o clearing breakpoints", unpack(opts) }
		)
	end,
}
