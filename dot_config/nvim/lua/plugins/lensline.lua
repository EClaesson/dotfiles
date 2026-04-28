return {
	"oribarilan/lensline.nvim",
	event = "LspAttach",
	config = function()
		require("lensline").setup({
			profiles = {
				{
					name = "minimal",
					style = {
						render = "all",
						placement = "inline",
						prefix = "",
					},
					providers = {
						{ name = "usages", enabled = true },
						{ name = "diagnostics", enabled = true },
					},
				},
			},
		})
	end,
}
