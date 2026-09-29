return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			yaml = { "yamllint" },
		}

		lint.linters.yamllint.env = {
			YAMLLINT_CONFIG_FILE = vim.fn.stdpath("config") .. "/tool_config/yamllint.yaml",
		}

		local function is_cloudformation(bufnr)
			if not vim.tbl_contains({ "yaml", "json" }, vim.bo[bufnr].filetype) then
				return false
			end
			local text = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, 200, false), "\n")
			return text:find("AWSTemplateFormatVersion") ~= nil
				or (text:find("Resources") ~= nil and text:find("AWS::%w+::%w+") ~= nil)
		end

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function(args)
				if vim.bo.modifiable then
					lint.try_lint()
					if is_cloudformation(args.buf) then
						lint.try_lint("cfn_lint")
					end
					if args.event == "BufWritePost" and vim.bo[args.buf].filetype == "go" then
						lint.try_lint("golangcilint")
					end
				end
			end,
		})
	end,
}
