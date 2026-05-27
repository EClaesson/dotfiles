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

		-- local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
		-- vim.api.nvim_create_autocmd("BufWritePre", {
		--	pattern = "*.go",
		--	callback = function()
		--		require("go.format").goimports()
		--	end,
		--	group = format_sync_grp,
		--})
	end,
	event = { "CmdlineEnter" },
	ft = { "go", "gomod" },
}
