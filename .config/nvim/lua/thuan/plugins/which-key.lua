return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		--@type false | "classic" | "modern" | "helix"
		preset = "helix",
		-- Delay before showing the popup. Can be a number or a function that returns a number.
		---@type number | fun(ctx: { keys: string, mode: string, plugin?: string }):number
		delay = function(ctx)
			return ctx.plugin and 0 or 200
		end,
	},
}
