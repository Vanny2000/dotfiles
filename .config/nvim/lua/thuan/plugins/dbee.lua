return {
	"kndndrj/nvim-dbee",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	build = function()
		-- Install tries to automatically detect the install method.
		-- if it fails, try calling it with one of these parameters:
		--    "curl", "wget", "bitsadmin", "go"
		require("dbee").install()
	end,
	config = function()
		require("dbee").setup(--[[optional config]])
		vim.keymap.set("n", "<leader>df", "<cmd>Dbee toggle<cr>", { desc = "[D]bee [F]orm" })
	end,
}
