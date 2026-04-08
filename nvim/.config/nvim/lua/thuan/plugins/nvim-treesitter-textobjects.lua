return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("nvim-treesitter-textobjects").setup({
			select = {
				lookahead = true,
			},
			move = {
				set_jumps = true,
			},
		})

		local select = require("nvim-treesitter-textobjects.select")
		local swap = require("nvim-treesitter-textobjects.swap")
		local move = require("nvim-treesitter-textobjects.move")
		local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

		-- ─── Select ──────────────────────────────────────────────────────────
		local select_keymaps = {
			["a="] = { "@assignment.outer", "Select outer part of an assignment" },
			["i="] = { "@assignment.inner", "Select inner part of an assignment" },
			["l="] = { "@assignment.lhs", "Select left hand side of an assignment" },
			["r="] = { "@assignment.rhs", "Select right hand side of an assignment" },

			-- works for js/ts (custom capture in after/queries/ecma/textobjects.scm)
			["a:"] = { "@property.outer", "Select outer part of an object property" },
			["i:"] = { "@property.inner", "Select inner part of an object property" },
			["l:"] = { "@property.lhs", "Select left part of an object property" },
			["r:"] = { "@property.rhs", "Select right part of an object property" },

			["aa"] = { "@parameter.outer", "Select outer part of a parameter/argument" },
			["ia"] = { "@parameter.inner", "Select inner part of a parameter/argument" },

			["ai"] = { "@conditional.outer", "Select outer part of a conditional" },
			["ii"] = { "@conditional.inner", "Select inner part of a conditional" },

			["al"] = { "@loop.outer", "Select outer part of a loop" },
			["il"] = { "@loop.inner", "Select inner part of a loop" },

			["af"] = { "@call.outer", "Select outer part of a function call" },
			["if"] = { "@call.inner", "Select inner part of a function call" },

			["am"] = { "@function.outer", "Select outer part of a method/function definition" },
			["im"] = { "@function.inner", "Select inner part of a method/function definition" },

			["ac"] = { "@class.outer", "Select outer part of a class" },
			["ic"] = { "@class.inner", "Select inner part of a class" },
		}
		for lhs, spec in pairs(select_keymaps) do
			vim.keymap.set({ "x", "o" }, lhs, function()
				select.select_textobject(spec[1], "textobjects")
			end, { desc = spec[2] })
		end

		-- ─── Swap ────────────────────────────────────────────────────────────
		local swap_next = {
			["<leader>na"] = { "@parameter.inner", "Swap parameter with next" },
			["<leader>n:"] = { "@property.outer", "Swap object property with next" },
			["<leader>nm"] = { "@function.outer", "Swap function with next" },
		}
		for lhs, spec in pairs(swap_next) do
			vim.keymap.set("n", lhs, function()
				swap.swap_next(spec[1])
			end, { desc = spec[2] })
		end

		local swap_previous = {
			["<leader>pa"] = { "@parameter.inner", "Swap parameter with previous" },
			["<leader>p:"] = { "@property.outer", "Swap object property with previous" },
			["<leader>pm"] = { "@function.outer", "Swap function with previous" },
		}
		for lhs, spec in pairs(swap_previous) do
			vim.keymap.set("n", lhs, function()
				swap.swap_previous(spec[1])
			end, { desc = spec[2] })
		end

		-- ─── Move ────────────────────────────────────────────────────────────
		-- Move functions auto-track the last call so `,` / `;` (bound below)
		-- can repeat them — no make_repeatable_move_pair needed.
		local function map_move(lhs, fn, query, group, desc)
			vim.keymap.set({ "n", "x", "o" }, lhs, function()
				fn(query, group)
			end, { desc = desc })
		end

		local goto_next_start = {
			["]f"] = { "@call.outer", "textobjects", "Next function call start" },
			["]m"] = { "@function.outer", "textobjects", "Next method/function def start" },
			["]c"] = { "@class.outer", "textobjects", "Next class start" },
			["]i"] = { "@conditional.outer", "textobjects", "Next conditional start" },
			["]l"] = { "@loop.outer", "textobjects", "Next loop start" },
			["]s"] = { "@scope", "locals", "Next scope" },
			["]z"] = { "@fold", "folds", "Next fold" },
		}
		for lhs, spec in pairs(goto_next_start) do
			map_move(lhs, move.goto_next_start, spec[1], spec[2], spec[3])
		end

		local goto_next_end = {
			["]F"] = { "@call.outer", "Next function call end" },
			["]M"] = { "@function.outer", "Next method/function def end" },
			["]C"] = { "@class.outer", "Next class end" },
			["]I"] = { "@conditional.outer", "Next conditional end" },
			["]L"] = { "@loop.outer", "Next loop end" },
		}
		for lhs, spec in pairs(goto_next_end) do
			map_move(lhs, move.goto_next_end, spec[1], "textobjects", spec[2])
		end

		local goto_previous_start = {
			["[f"] = { "@call.outer", "Prev function call start" },
			["[m"] = { "@function.outer", "Prev method/function def start" },
			["[c"] = { "@class.outer", "Prev class start" },
			["[i"] = { "@conditional.outer", "Prev conditional start" },
			["[l"] = { "@loop.outer", "Prev loop start" },
		}
		for lhs, spec in pairs(goto_previous_start) do
			map_move(lhs, move.goto_previous_start, spec[1], "textobjects", spec[2])
		end

		local goto_previous_end = {
			["[F"] = { "@call.outer", "Prev function call end" },
			["[M"] = { "@function.outer", "Prev method/function def end" },
			["[C"] = { "@class.outer", "Prev class end" },
			["[I"] = { "@conditional.outer", "Prev conditional end" },
			["[L"] = { "@loop.outer", "Prev loop end" },
		}
		for lhs, spec in pairs(goto_previous_end) do
			map_move(lhs, move.goto_previous_end, spec[1], "textobjects", spec[2])
		end

		-- ─── Repeatable moves ────────────────────────────────────────────────
		-- vim way: ; goes to the direction you were moving.
		vim.keymap.set({ "n", "x", "o" }, ",", function()
			ts_repeat_move.repeat_last_move()
			vim.cmd("normal! zz")
		end)

		vim.keymap.set({ "n", "x", "o" }, ";", function()
			ts_repeat_move.repeat_last_move_opposite()
			vim.cmd("normal! zz")
		end)
	end,
}
