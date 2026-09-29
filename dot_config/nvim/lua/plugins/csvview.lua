return {
	"hat0uma/csvview.nvim",
	ft = { "csv", "tsv" },
	cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
	keys = {
		{ "<leader>tc", "<cmd>CsvViewToggle<cr>", desc = "Toggle [C]SV View" },
	},
	opts = {
		keymaps = {
			textobject_field_inner = { "if", mode = { "o", "x" } },
			textobject_field_outer = { "af", mode = { "o", "x" } },
			jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
			jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
		},
	},
	config = function(_, opts)
		require("csvview").setup(opts)
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("csvview-auto", { clear = true }),
			pattern = { "csv", "tsv" },
			callback = function(args)
				require("csvview").enable(args.buf)
			end,
		})
		if vim.tbl_contains({ "csv", "tsv" }, vim.bo.filetype) then
			require("csvview").enable(0)
		end
	end,
}
