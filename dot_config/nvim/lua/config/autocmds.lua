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

vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "*",
	callback = function()
		if not ((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i") then
			return
		end
		if vim.snippet.active() then
			vim.snippet.stop()
		end
		local luasnip = package.loaded["luasnip"]
		if
			luasnip
			and luasnip.session.current_nodes[vim.api.nvim_get_current_buf()]
			and not luasnip.session.jump_active
		then
			luasnip.unlink_current()
		end
	end,
})
