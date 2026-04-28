return {
	"MagicDuck/grug-far.nvim",
	config = function()
		require("grug-far").setup({
			windowCreationCommand = "tabnew",
		})

		vim.keymap.set(
			"n",
			"<leader>se",
			"<cmd>lua require('grug-far').open()<CR>",
			{ desc = "[S]earch and R[e]place" }
		)
		vim.keymap.set(
			"n",
			"<leader>sE",
			"<cmd>lua require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } })<CR>",
			{ desc = "[S]earch and R[E]place in buffer" }
		)
	end,
}
