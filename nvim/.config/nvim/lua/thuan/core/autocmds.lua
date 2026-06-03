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

-- Close help window with 'q'

create_autocmd("FileType", {
	pattern = { "help" },
	callback = function()
		vim.keymap.set("n", "q", "<cmd>quit<cr>", { buffer = true, silent = true })
	end,
})

vim.filetype.add({
	extension = {
		yml = function(path)
			return path:match("ansible") and "yaml.ansible" or "yaml"
		end,
		yaml = function(path)
			return path:match("ansible") and "yaml.ansible" or "yaml"
		end,
	},
	pattern = {
		[".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
		[".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
		[".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
		[".*/roles/.*/meta/.*%.ya?ml"] = "yaml.ansible",
		[".*/group_vars/.*%.ya?ml"] = "yaml.ansible",
		[".*/host_vars/.*%.ya?ml"] = "yaml.ansible",
		[".*%.ansible%.ya?ml"] = "yaml.ansible",
	},
})
