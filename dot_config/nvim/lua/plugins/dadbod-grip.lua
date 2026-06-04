return {
	"joryeugene/dadbod-grip.nvim",
	dependencies = {
		"tpope/vim-dadbod",
	},
	cmd = { "Grip", "GripStart", "GripConnect" },
	keys = {
		{ "<leader>ec", "<cmd>GripConnect<cr>", desc = "[C]onnect" },
		{ "<leader>eg", "<cmd>Grip<cr>", desc = "[G]rid" },
		{ "<leader>et", "<cmd>GripTables<cr>", desc = "[T]ables" },
		{ "<leader>eq", "<cmd>GripQuery<cr>", desc = "[Q]uery Pad" },
		{ "<leader>es", "<cmd>GripSchema<cr>", desc = "[S]chema" },
		{ "<leader>eh", "<cmd>GripHistory<cr>", desc = "[H]istory" },
	},
	opts = {
		picker = "telescope",
	},
}
