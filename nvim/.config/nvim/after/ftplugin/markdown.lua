local keymap = vim.keymap
keymap.set("n", "<leader>od", "<cmd>ObsidianDailies<CR>", { desc = "Open/Create daily notes" })
keymap.set("n", "<leader>ot", "<cmd>ObsidianNewFromTemplate<CR>", { desc = "Create new note from template" })
keymap.set("v", "<leader>oe", "<cmd>ObsidianExtractNote<CR>", { desc = "Extact note" })
keymap.set("n", "<leader>ow", "<cmd>ObsidianWorkspace<CR>", { desc = "Switch Workspaces" })
keymap.set("n", "<leader>op", "<cmd>ObsidianPasteImg<CR>", { desc = "Paste image" })
keymap.set("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "New note" })
