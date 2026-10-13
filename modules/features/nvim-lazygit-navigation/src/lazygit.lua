local function get_commit_hash_at_cursor()
	local buffer = vim.api.nvim_buf_get_name(0)
	local linenr = vim.api.nvim_win_get_cursor(0)[1]

	local hash = vim.fn
		.systemlist({
			"git",
			"blame",
			"-L",
			string.format("%d,%d", linenr, linenr),
			"--line-porcelain",
			buffer,
		})[1]
		:match("^(%S+)")

	if hash:match("^0+$") then
		return nil
	end

	return hash
end

-- run lazygit
vim.api.nvim_create_user_command("LazyGit", function()
	vim.fn.system({ "topen", "--", "lazygit" })
end, { nargs = 0 })

-- run lazygit and focus git log
vim.api.nvim_create_user_command("LazyGitLog", function()
	vim.fn.system({ "topen", "--force", "--", "lazygit", "log" })
end, { nargs = 0 })

-- run lazygit and focus git log for current buffer
vim.api.nvim_create_user_command("LazyGitFileFilter", function()
	local buff = vim.api.nvim_buf_get_name(0)
	vim.fn.system({ "topen", "--force", "--", "lazygit", "--filter", buff })
end, { nargs = 0 })

-- run lazygit and focus git log for commit hash at cursor
vim.api.nvim_create_user_command("LazyGitHashFilter", function()
	local buff = vim.api.nvim_buf_get_name(0)
	local hash = get_commit_hash_at_cursor()
	if hash ~= nil then
		vim.fn.system({ "topen", "--force", "--keys", "/", hash, "ENTER", "ENTER", "--", "lazygit", "--filter", buff })
	else
		vim.notify("LazyGitHashFilter failed: No commit hash at cursor", vim.log.levels.ERROR)
	end
end, { nargs = 0 })

vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "lazyGit: Start" })
vim.keymap.set("n", "<leader>gl", "<cmd>LazyGitLog<CR>", { desc = "lazyGit: Open log" })
vim.keymap.set("n", "<leader>gbl", "<cmd>LazyGitFileFilter<CR>", { desc = "lazyGit: Open log for current buffer" })
vim.keymap.set("n", "<leader>gL", "<cmd>LazyGitHashFilter<CR>", { desc = "lazyGit: Open log for current line hash" })
