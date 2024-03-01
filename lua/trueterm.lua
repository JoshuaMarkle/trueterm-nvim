local M = {}

function M.run_code_in_terminal()
	local terminal_buf = nil

	-- Find an existing terminal buffer
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buftype == "terminal" then
			terminal_buf = buf
			break
		end
	end

	-- If no terminal buffer was found, create a new one
	if terminal_buf == nil then
		vim.cmd("vsplit | terminal")
		terminal_buf = vim.api.nvim_get_current_buf()
	else
		-- Focus the terminal buffer if it's not the current buffer
		local found = false
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_get_buf(win) == terminal_buf then
				vim.api.nvim_set_current_win(win)
				found = true
				break
			end
		end
		-- If the terminal buffer was not visible in any window, open it
		if not found then
			vim.cmd("vsplit")
			vim.api.nvim_win_set_buf(0, terminal_buf)
		end
	end

	-- Ensure the terminal is in insert mode before sending the command
	vim.cmd("startinsert")

	-- Send the command to the terminal
	vim.fn.chansend(vim.b[terminal_buf].terminal_job_id, "echo hi there\n")
end

return M
