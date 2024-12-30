require("thuan.core")
require("thuan.lazy")
require("luasnip.loaders.from_lua").load({
	paths = { "~/.config/nvim/snippets/" },
})
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Source file" })
vim.keymap.set("n", "<leader>x", ":.lua<CR>", { desc = "Run this line" })
vim.keymap.set("v", "<leader>x", ":lua<CR>", { desc = "Run selections" })
