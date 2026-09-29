return {
	"MagicDuck/grug-far.nvim",
	cmd = { "GrugFar", "GrugFarWithin" },
	keys = {
		{ "<leader>se", "<cmd>lua require('grug-far').open()<CR>", desc = "Search and R[e]place" },
		{
			"<leader>sE",
			"<cmd>lua require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } })<CR>",
			desc = "Search and R[E]place in Buffer",
		},
		{
			"<leader>sv",
			function()
				require("grug-far").open({ visualSelectionUsage = "operate-within-range" })
			end,
			mode = "x",
			desc = "Search & Replace in [V]isual Selection",
		},
	},
	opts = {
		windowCreationCommand = "tabnew",
	},
}
