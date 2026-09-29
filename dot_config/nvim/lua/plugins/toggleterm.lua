return {
	"akinsho/toggleterm.nvim",
	config = true,
	keys = {
		{ "<leader>T1", "<cmd>1ToggleTerm<cr>", desc = "Terminal [1] (Horizontal)" },
		{ "<leader>T2", "<cmd>2ToggleTerm<cr>", desc = "Terminal [2] (Horizontal)" },
		{ "<leader>T3", "<cmd>3ToggleTerm<cr>", desc = "Terminal [3] (Horizontal)" },
		{
			"<leader>T4",
			"<cmd>4ToggleTerm direction=vertical size=80<cr>",
			desc = "Terminal [4] (Vertical)",
		},
		{
			"<leader>T5",
			"<cmd>5ToggleTerm direction=vertical size=80<cr>",
			desc = "Terminal [5] (Vertical)",
		},
		{
			"<leader>T6",
			"<cmd>6ToggleTerm direction=vertical size=80<cr>",
			desc = "Terminal [6] (Vertical)",
		},
		{ "<leader>Tt", "<cmd>terminal<cr>", desc = "[T]erminal (Buffer)" },
		{ "<leader>Ta", "<cmd>ToggleTermToggleAll<cr>", desc = "Toggle [A]ll" },
	},
}
