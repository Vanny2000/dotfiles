local keymap = vim.keymap
keymap.set("n", "<leader>od", "<cmd>Obsidian dailies<CR>", { desc = "Open/Create daily notes" })
keymap.set("n", "<leader>ot", "<cmd>Obsidian new_from_template<CR>", { desc = "Create new note from template" })
keymap.set("v", "<leader>oe", "<cmd>Obsidian extract_note<CR>", { desc = "Extact note" })
keymap.set("n", "<leader>ow", "<cmd>Obsidian  workspace<CR>", { desc = "Switch Workspaces" })
keymap.set("n", "<leader>op", "<cmd>Obsidian paste_img<CR>", { desc = "Paste image" })
keymap.set("n", "<leader>on", "<cmd>Obsidian new<CR>", { desc = "New note" })
