return {
	"nvim-mini/mini.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<leader>bd",
			function()
				require("mini.bufremove").delete()
			end,
			desc = "[B]uffer [D]elete",
		},
		{
			"<leader>bD",
			function()
				require("mini.bufremove").delete(0, true)
			end,
			desc = "[B]uffer [D]elete (force)",
		},
	},
	config = function()
		require("mini.ai").setup({ n_lines = 500 })
		require("mini.surround").setup({
			mappings = {
				add = "gsa",
				delete = "gsd",
				find = "gsf",
				find_left = "gsF",
				highlight = "gsh",
				replace = "gsr",

				suffix_last = "gsl",
				suffix_next = "gsn",
			},
		})
		require("mini.splitjoin").setup()
		require("mini.indentscope").setup({
			draw = {
				delay = 0,
				animation = require("mini.indentscope").gen_animation.none(),
			},
		})
		require("mini.cursorword").setup()
		require("mini.trailspace").setup()
		require("mini.diff").setup()
		require("mini.bufremove").setup({
			silent = true,
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("trim-trailing-whitespace", { clear = true }),
			callback = function()
				local skip_ft = { markdown = true, diff = true }

				if skip_ft[vim.bo.filetype] then
					return
				end

				local ok, trailspace = pcall(require, "mini.trailspace")
				if ok then
					trailspace.trim()
					trailspace.trim_last_lines()
				end
			end,
		})
	end,
}
