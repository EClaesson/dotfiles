return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-mini/mini.nvim",
	},
	keys = {
		{ "<leader>tm", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle [M]arkdown Rendering" },
	},
	opts = {
		completions = {
			lsp = { enabled = true },
		},
	},
	ft = { "markdown", "codecompanion" },
}
