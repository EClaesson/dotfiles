return {
	"rmagatti/auto-session",
	lazy = false,
	config = function()
		require("auto-session").setup({
			suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			show_auto_restore_notif = true,
		})
	end,
}
