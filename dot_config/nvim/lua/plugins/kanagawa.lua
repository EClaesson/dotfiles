return {
	"rebelot/kanagawa.nvim",
	priority = 1000,
	config = function()
		require("kanagawa").setup({
			theme = "wave",
			background = {
				dark = "wave",
				light = "lotus",
			},
			overrides = function(colors)
				local theme = colors.theme

				local makeDiagnosticColor = function(color)
					local c = require("kanagawa.lib.color")
					return { fg = color, bg = c(color):blend(theme.ui.bg, 0.975):to_hex() }
				end

				return {
					Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
					PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
					PmenuSbar = { bg = theme.ui.bg_m1 },
					PmenuThumb = { bg = theme.ui.bg_p2 },
					DiagnosticVirtualTextHint = makeDiagnosticColor(theme.diag.hint),
					DiagnosticVirtualTextInfo = makeDiagnosticColor(theme.diag.info),
					DiagnosticVirtualTextWarn = makeDiagnosticColor(theme.diag.warning),
					DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),
				}
			end,
		})

		vim.cmd.colorscheme("kanagawa")
		vim.api.nvim_set_hl(0, "WinBar", { link = "StatusLine" })
		vim.api.nvim_set_hl(0, "WinBarNC", { link = "StatusLineNC" })
	end,
}
