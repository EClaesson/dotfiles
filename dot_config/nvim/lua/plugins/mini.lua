return {
	"nvim-mini/mini.nvim",
	event = "VeryLazy",
	module = false,
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	keys = {
		{
			"<leader>bd",
			function()
				require("mini.bufremove").delete()
			end,
			desc = "Buffer [D]elete",
		},
		{
			"<leader>bD",
			function()
				require("mini.bufremove").delete(0, true)
			end,
			desc = "Buffer [D]elete (Force)",
		},
	},
	config = function()
		local ai = require("mini.ai")
		ai.setup({
			n_lines = 500,
			custom_textobjects = {
				F = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
				c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
			},
		})
		require("mini.surround").setup({
			mappings = {
				add = "gsa",
				delete = "gsd",
				find = "gsf",
				find_left = "gsF",
				highlight = "gsh",
				replace = "gsr",

				suffix_last = "l",
				suffix_next = "n",
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
