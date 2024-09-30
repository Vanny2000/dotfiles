return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

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

		-- DAP UI setup
		dapui.setup()

		-- Automatically open dapui when debugging starts
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		local keymap = vim.keymap
		-- Key mappings for debugging
		-- Continue execution
		keymap.set("n", "<F5>", function()
			require("dap").continue()
		end, { desc = "Debug: Continue" })

		-- Step over (execute the current line and move to the next one)
		keymap.set("n", "<leader>bb", function()
			require("dap").step_over()
		end, { desc = "Debug: Step Over" })

		-- Step into (step into a function call)
		keymap.set("n", "<leader>bi", function()
			require("dap").step_into()
		end, { desc = "Debug: Step Into" })

		-- Step out (finish executing the current function and return to the caller)
		keymap.set("n", "<F12>", function()
			require("dap").step_out()
		end, { desc = "Debug: Step Out" })

		-- Toggle breakpoint at the current line
		keymap.set("n", "<leader>p", function()
			require("dap").toggle_breakpoint()
		end, { desc = "Debug: Toggle Breakpoint" })

		-- Terminate the debugging session
		keymap.set("n", "<F6>", function()
			require("dap").terminate()
		end, { desc = "Debug: Terminate Session" })

		-- Clear all breakpoints, close the debug UI, and terminate the session
		keymap.set("n", "<leader>bc", function()
			require("dap").clear_breakpoints()
			require("dapui").close()
			require("dap").terminate()
		end, { desc = "Debug: Clear All, Close UI, Terminate" })
	end,
}
