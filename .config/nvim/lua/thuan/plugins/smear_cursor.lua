return {
	"sphamba/smear-cursor.nvim",

	opts = {
		-- Smear cursor when switching buffers or windows.
		smear_between_buffers = true,

		-- Smear cursor when moving within line or to neighbor lines.
		-- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control
		smear_between_neighbor_lines = true,

		-- Draw the smear in buffer space instead of screen space when scrolling
		scroll_buffer_space = true,

		-- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
		-- Smears will blend better on all backgrounds.
		legacy_computing_symbols_support = true,

		-- Smear cursor in insert mode.
		-- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
		smear_insert_mode = true,
		-- Smear cursor color. Defaults to Cursor GUI color if not set.
		-- Set to "none" to match the text color at the target cursor position.
		-- cursor_color = "#CBE0F0",
		stiffness = 0.6,
		trailing_stiffness = 0.3,
		distance_stop_animating = 0.5,
	},
}
