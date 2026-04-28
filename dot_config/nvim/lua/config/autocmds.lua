vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	pattern = "*",
	callback = function()
		if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" and vim.bo.buftype == "" then
			vim.cmd("checktime")
		end
	end,
})
