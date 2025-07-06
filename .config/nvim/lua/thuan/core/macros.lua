local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)

-- dd() the selected text in laravel.
vim.fn.setreg("l", "yodd() .. " .. esc .. "i''" .. esc .. "hpa:" .. esc .. "la," .. esc .. "pA;" .. esc .. "")
