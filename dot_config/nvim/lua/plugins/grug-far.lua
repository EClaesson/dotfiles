return {
	"MagicDuck/grug-far.nvim",
	config = function()
		require("grug-far").setup({
			windowCreationCommand = "tabnew",
		})

		vim.keymap.set("n", "<leader>se", "<cmd>lua require('grug-far').open()<CR>", { desc = "Search and R[e]place" })
		vim.keymap.set(
			"n",
			"<leader>sE",
			"<cmd>lua require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } })<CR>",
			{ desc = "Search and R[E]place in Buffer" }
		)
		vim.keymap.set({ "n", "x" }, "<leader>sv", function()
			require("grug-far").open({ visualSelectionUsage = "operate-within-range" })
		end, { desc = "Search & Replace in [V]isual Selection" })
	end,
}
