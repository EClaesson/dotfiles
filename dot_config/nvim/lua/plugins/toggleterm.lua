return {
	"akinsho/toggleterm.nvim",
	config = true,
	keys = {
		{ "<leader>T1", "<cmd>1ToggleTerm<cr>", mode = { "n", "t" }, desc = "[T]erminal [1] (Horizontal)" },
		{ "<leader>T2", "<cmd>2ToggleTerm<cr>", mode = { "n", "t" }, desc = "[T]erminal [2] (Horizontal)" },
		{ "<leader>T3", "<cmd>3ToggleTerm<cr>", mode = { "n", "t" }, desc = "[T]erminal [3] (Horizontal)" },
		{
			"<leader>T4",
			"<cmd>4ToggleTerm direction=vertical size=80<cr>",
			mode = { "n", "t" },
			desc = "[T]erminal [4] (Vertical)",
		},
		{
			"<leader>T5",
			"<cmd>5ToggleTerm direction=vertical size=80<cr>",
			mode = { "n", "t" },
			desc = "[T]erminal [5] (Vertical)",
		},
		{
			"<leader>T6",
			"<cmd>6ToggleTerm direction=vertical size=80<cr>",
			mode = { "n", "t" },
			desc = "[T]erminal [6] (Vertical)",
		},
		{ "<leader>T7", "<cmd>:terminal<cr>", mode = { "n", "t" }, desc = "[T]erminal [7] (Buffer)" },
		{ "<leader>T0", "<cmd>ToggleTermToggleAll<cr>", mode = { "n", "t" }, desc = "[T]erminal toggle [0] all" },
	},
}
