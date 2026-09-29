vim.g.rustaceanvim = {
	server = {
		default_settings = {
			["rust-analyzer"] = {
				procMacro = { enable = true },
				check = { command = "clippy" },
			},
		},
	},
}

return {
	"mrcjkb/rustaceanvim",
	lazy = false,
}
