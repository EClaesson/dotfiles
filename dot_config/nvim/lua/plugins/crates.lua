return {
	"saecki/crates.nvim",
	opts = {
		lsp = {
			enabled = true,
			actions = true,
			completion = true,
			hover = true,
		},
		completion = {
			crates = {
				enabled = true,
				max_results = 8,
				min_chars = 4,
			},
		},
	},
}
