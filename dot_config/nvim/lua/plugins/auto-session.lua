return {
	"rmagatti/auto-session",
	lazy = false,
	config = function()
		require("auto-session").setup({
			suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			show_auto_restore_notif = true,
			pre_save_cmds = {
				function()
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						if vim.api.nvim_buf_get_name(buf):match("^grip://") then
							vim.bo[buf].buflisted = false
						end
					end
				end,
			},
		})
	end,
}
