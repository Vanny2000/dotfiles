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
