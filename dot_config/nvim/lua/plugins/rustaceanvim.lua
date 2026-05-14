vim.g.rustaceanvim = {
	server = {
		default_settings = {
			["rust-analyzer"] = {
				procMacro = { enable = true },
			},
		},
	},
}

return {
	"mrcjkb/rustaceanvim",
	lazy = true,
	ft = "rust",
}
