-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("n", "<leader>x", ":.lua<CR>", { desc = "Run this line" })
keymap.set("v", "<leader>x", ":lua<CR>", { desc = "Run selections" })
---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
-- clear quickfix list
keymap.set("n", "<leader>cc", ":cexpr []<CR>", { desc = "Clear quickfix list" })

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- saving files
keymap.set("n", "<leader>ss", "<cmd>w<CR>", { desc = "Save file" })
keymap.set("n", "<leader>sa", "<cmd>wa<CR>", { desc = "Save all files" })
keymap.set("n", "<leader>q", "<cmd>q!<CR>", { desc = "Quit without saving" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- horizontal movement
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Moving down half a page" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Moving up half a page" })
-- searching with centered view
keymap.set("n", "n", "nzzzv", { desc = "Searching with centered view" })
keymap.set("n", "N", "Nzzzv", { desc = "Searching with centered view" })
keymap.set("n", "G", "Gzz", { desc = "Move to top and center the view" })

-- live servers
keymap.set("n", "<leader>ls", "<cmd>LiveServerStart<CR>", { desc = "Start Live Server" })
keymap.set("n", "<leader>lq", "<cmd>LiveServerStop<CR>", { desc = "Stop Live Server" })
-- env operations
keymap.set("n", "<leader>fe", "<cmd>e .env<CR>", { desc = "Open/Create .env file" })
