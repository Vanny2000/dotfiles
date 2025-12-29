-- Word lists for dynamic name generation
local adjectives = {
	"swift", "lazy", "async", "static", "atomic", "cosmic", "hyper", "mega", "nano", "turbo",
	"dark", "bright", "silent", "loud", "fast", "slow", "hot", "cold", "wild", "calm",
	"crypto", "quantum", "neural", "stealth", "phantom", "shadow", "ghost", "cyber", "neon", "void",
}

local nouns = {
	"lambda", "kernel", "daemon", "socket", "buffer", "node", "thread", "pixel", "byte", "spark",
	"pulse", "flux", "core", "matrix", "cipher", "nexus", "forge", "vault", "link", "wave",
	"storm", "blade", "prism", "orbit", "quark", "photon", "vector", "tensor", "beacon", "relay",
}

local state = {
	terminals = {}, -- List of { buf = number, name = string }
	current_index = 0, -- Current terminal index (0 = none active)
	win = -1, -- Floating window
}

-- Generate a random name
local function generate_name()
	math.randomseed(os.time() + math.random(1000))
	local adj = adjectives[math.random(#adjectives)]
	local noun = nouns[math.random(#nouns)]
	return adj .. "-" .. noun
end

-- Get a unique name (append number if duplicate)
local function get_unique_name()
	local base_name = generate_name()
	local name = base_name
	local counter = 2

	-- Check if name already exists
	local function name_exists(n)
		for _, term in ipairs(state.terminals) do
			if term.name == n then
				return true
			end
		end
		return false
	end

	while name_exists(name) do
		name = base_name .. "-" .. counter
		counter = counter + 1
	end

	return name
end

local function create_floating_window(opts)
	opts = opts or {}
	local width = opts.width or math.floor(vim.o.columns * 0.9)
	local height = opts.height or math.floor(vim.o.lines * 0.9)

	-- Calculate the position to center the window
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	-- Create a buffer
	local buf = nil
	if opts.buf and vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
	end

	-- Define window configuration
	local win_config = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal", -- No borders or extra UI elements
		border = "rounded",
	}

	-- Create the floating window
	local win = vim.api.nvim_open_win(buf, true, win_config)

	return { buf = buf, win = win }
end

-- Get valid terminals (filter out invalid buffers)
local function get_valid_terminals()
	local valid = {}
	for _, term in ipairs(state.terminals) do
		if vim.api.nvim_buf_is_valid(term.buf) then
			table.insert(valid, term)
		end
	end
	state.terminals = valid
	return valid
end

-- Update window title to show terminal name and index
local function update_title()
	if vim.api.nvim_win_is_valid(state.win) then
		local total = #state.terminals
		local name = state.terminals[state.current_index] and state.terminals[state.current_index].name or "terminal"
		local title = string.format(" %s (%d/%d) ", name, state.current_index, total)
		vim.api.nvim_win_set_config(state.win, { title = title, title_pos = "center" })
	end
end

-- Show a specific terminal by index
local function show_terminal(index)
	local terminals = get_valid_terminals()
	if #terminals == 0 or index < 1 or index > #terminals then
		return
	end

	state.current_index = index
	local buf = terminals[index].buf

	if vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_set_buf(state.win, buf)
	else
		local result = create_floating_window({ buf = buf })
		state.win = result.win
	end

	update_title()
	vim.cmd("startinsert")
end

-- Toggle the floating terminal window
local function toggle_terminal()
	if vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_hide(state.win)
		return
	end

	local terminals = get_valid_terminals()

	-- If no terminals exist, create one
	if #terminals == 0 then
		local result = create_floating_window({})
		state.win = result.win
		vim.cmd.terminal()
		table.insert(state.terminals, { buf = vim.api.nvim_get_current_buf(), name = get_unique_name() })
		state.current_index = 1
		update_title()
		vim.cmd("startinsert")
	else
		-- Show the last active terminal
		if state.current_index < 1 or state.current_index > #terminals then
			state.current_index = 1
		end
		show_terminal(state.current_index)
	end
end

-- Add a new terminal
local function add_terminal()
	-- Ensure window is open
	if not vim.api.nvim_win_is_valid(state.win) then
		toggle_terminal()
		return
	end

	-- Create new terminal buffer
	local buf = vim.api.nvim_create_buf(false, true)
	local name = get_unique_name()
	table.insert(state.terminals, { buf = buf, name = name })
	state.current_index = #state.terminals

	vim.api.nvim_win_set_buf(state.win, buf)
	vim.cmd.terminal()
	-- Update buffer reference after terminal() creates new buffer
	state.terminals[state.current_index].buf = vim.api.nvim_get_current_buf()

	update_title()
	vim.cmd("startinsert")
end

-- Delete the current terminal
local function delete_terminal()
	local terminals = get_valid_terminals()
	if #terminals == 0 then
		return
	end

	local term_to_delete = terminals[state.current_index]
	local buf_to_delete = term_to_delete.buf

	-- Remove from list
	table.remove(state.terminals, state.current_index)
	terminals = get_valid_terminals()

	-- Delete the buffer
	if vim.api.nvim_buf_is_valid(buf_to_delete) then
		vim.api.nvim_buf_delete(buf_to_delete, { force = true })
	end

	-- If no terminals left, close window
	if #terminals == 0 then
		if vim.api.nvim_win_is_valid(state.win) then
			vim.api.nvim_win_hide(state.win)
		end
		state.current_index = 0
		return
	end

	-- Adjust index and show next terminal
	if state.current_index > #terminals then
		state.current_index = #terminals
	end
	show_terminal(state.current_index)
end

-- Navigate to next terminal
local function next_terminal()
	local terminals = get_valid_terminals()
	if #terminals <= 1 then
		return
	end

	local new_index = state.current_index + 1
	if new_index > #terminals then
		new_index = 1
	end
	show_terminal(new_index)
end

-- Navigate to previous terminal
local function prev_terminal()
	local terminals = get_valid_terminals()
	if #terminals <= 1 then
		return
	end

	local new_index = state.current_index - 1
	if new_index < 1 then
		new_index = #terminals
	end
	show_terminal(new_index)
end

-- Rename the current terminal
local function rename_terminal()
	local terminals = get_valid_terminals()
	if #terminals == 0 or state.current_index < 1 then
		return
	end

	local current_name = state.terminals[state.current_index].name
	vim.ui.input({ prompt = "Rename terminal: ", default = current_name }, function(new_name)
		if new_name and new_name ~= "" then
			state.terminals[state.current_index].name = new_name
			update_title()
		end
	end)
end

-- Commands and keymaps
vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})
vim.api.nvim_create_user_command("FloaterminalNew", add_terminal, {})
vim.api.nvim_create_user_command("FloaterminalDelete", delete_terminal, {})
vim.api.nvim_create_user_command("FloaterminalNext", next_terminal, {})
vim.api.nvim_create_user_command("FloaterminalPrev", prev_terminal, {})
vim.api.nvim_create_user_command("FloaterminalRename", rename_terminal, {})

-- Normal mode keymaps
vim.keymap.set({"n","t"}, "<leader>tt", toggle_terminal, { desc = "Toggle Floating Terminal" })

-- Terminal mode keymaps for navigation
vim.keymap.set("t", "<C-j>", prev_terminal, { desc = "Previous Terminal" })
vim.keymap.set("t", "<C-k>", next_terminal, { desc = "Next Terminal" })
vim.keymap.set("t", "<C-x>", delete_terminal, { desc = "Delete Current Terminal" })
vim.keymap.set("t", "<C-t>", add_terminal, { desc = "New Floating Terminal" })
vim.keymap.set("t", "<C-r>", rename_terminal, { desc = "Rename Current Terminal" })

-- Expose terminal status for statusline (e.g., lualine)
_G.floaterm_status = function()
	local terminals = get_valid_terminals()
	if #terminals == 0 then
		return nil
	end
	local current = state.terminals[state.current_index]
	local name = current and current.name or "terminal"
	return { name = name, index = state.current_index, count = #terminals }
end
