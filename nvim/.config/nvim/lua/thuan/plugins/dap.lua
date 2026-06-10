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
		local dap_vt = require("nvim-dap-virtual-text")

		dap_vt.setup({
			all_references = true,
			only_first_definition = false,
			display_callback = function(variable, _, _, _, options)
				if variable.type == "uninitialized" or variable.value == "uninitialized" then
					return nil
				end
				local value = variable.value:gsub("%s+", " ")
				if #value > 40 then
					value = value:sub(1, 39) .. "…"
				end
				if options.virt_text_pos == "inline" then
					return " = " .. value
				end
				return variable.name .. " = " .. value
			end,
		})
		-- PHP / Xdebug configuration
		dap.adapters.php = {
			type = "executable",
			command = vim.fn.exepath("php-debug-adapter"),
		}

		dap.configurations.php = {
			{
				type = "php",
				request = "launch",
				name = "Listen for Xdebug",
				port = 9003,
				pathMappings = {
					["/var/www/html"] = "${workspaceFolder}",
				},
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
						{ id = "repl", size = 0.8 },
						{ id = "watches", size = 0.2 },
					},
					position = "bottom",
					size = 12,
				},
			},
		})

		-- Auto-open UI when debugging starts
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end

		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end

		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
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
			dap_vt.toggle()
		end, { desc = "Reset Debug Session", unpack(opts) })

		-- Restart session without clearing breakpoints
		keymap.set("n", debug_prefix .. "x", function()
			dap.restart()
			dap_vt.toggle()
		end, { desc = "Reset Debug Session w/o clearing breakpoints", unpack(opts) })
	end,
}
