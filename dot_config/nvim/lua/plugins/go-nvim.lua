return {
	"ray-x/go.nvim",
	dependencies = {
		"ray-x/guihua.lua",
	},
	config = function()
		require("go").setup({
			icons = { breakpoint = "", currentpos = "" },
			trouble = true,
			luasnip = true,
			lsp_cfg = true,
			golangci_lint = {
				config = ".golangci.yml",
			},
		})
	end,
	event = { "CmdlineEnter" },
	ft = { "go", "gomod" },
}
