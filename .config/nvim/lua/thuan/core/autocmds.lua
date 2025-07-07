local create_autocmd = vim.api.nvim_create_autocmd

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  Se `:help vim.highlight.on_yank()`
create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Disable relative line numbers in Copilot buffers
create_autocmd("BufEnter", {
	pattern = "copilot-*",
	callback = function()
		-- Set buffer-local options
		vim.opt_local.relativenumber = false
		vim.opt_local.number = false
		vim.opt_local.conceallevel = 0
	end,
})
