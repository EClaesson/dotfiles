return {
	"ray-x/go.nvim",
	dependencies = {
		"ray-x/guihua.lua",
	},
	config = function()
		require("go").setup({
			icons = false,
			trouble = true,
			luasnip = true,
			lsp_cfg = true,
			lsp_keymaps = false,
			dap_debug_gui = false,
			dap_debug_keymap = false,
			dap_debug_vt = false,
			golangci_lint = {
				config = ".golangci.yml",
			},
		})
	end,
	ft = { "go", "gomod" },
}
