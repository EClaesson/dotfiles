return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	lazy = true,
	keys = {
		{
			"]f",
			function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Next Function Start",
		},
		{
			"[f",
			function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
			end,
			mode = { "n", "x", "o" },
			desc = "Previous Function Start",
		},
	},
}
