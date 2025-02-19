local keymap = vim.keymap
-- live servers
keymap.set("n", "<leader>ls", "<cmd>LiveServerStart<CR>", { desc = "Start Live Server" })
keymap.set("n", "<leader>lq", "<cmd>LiveServerStop<CR>", { desc = "Stop Live Server" })
