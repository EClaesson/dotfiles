local prettier_config_files = {
	".prettierrc",
	".prettierrc.json",
	".prettierrc.yml",
	".prettierrc.yaml",
	".prettierrc.json5",
	".prettierrc.js",
	".prettierrc.cjs",
	".prettierrc.mjs",
	".prettierrc.ts",
	".prettierrc.toml",
	"prettier.config.js",
	"prettier.config.cjs",
	"prettier.config.mjs",
	"prettier.config.ts",
}

local eslint_config_files = {
	"eslint.config.js",
	"eslint.config.mjs",
	"eslint.config.cjs",
	"eslint.config.ts",
	".eslintrc",
	".eslintrc.js",
	".eslintrc.cjs",
	".eslintrc.json",
	".eslintrc.yml",
	".eslintrc.yaml",
}

local function find_upward(bufnr, names)
	local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
	return vim.fs.find(names, { upward = true, path = dir })[1]
end

local function has_prettier_config(bufnr)
	if find_upward(bufnr, prettier_config_files) then
		return true
	end
	-- Prettier config can also live under a "prettier" key in package.json.
	local pkg = find_upward(bufnr, { "package.json" })
	if pkg then
		local ok, lines = pcall(vim.fn.readfile, pkg)
		if ok then
			for _, line in ipairs(lines) do
				if line:match('"prettier"%s*:') then
					return true
				end
			end
		end
	end
	return false
end

-- When the project configures Prettier, format with Prettier and keep ESLint for
-- linting. Otherwise fall back to eslint --fix (via eslint_d) for formatting when
-- an ESLint config is present, else defer to the LSP.
local function js_formatters(bufnr)
	if has_prettier_config(bufnr) then
		return { "prettier" }
	elseif find_upward(bufnr, eslint_config_files) then
		return { "eslint_d" }
	end
	return {}
end

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "[F]ormat Buffer",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			local disable_filetypes = { c = true, cpp = true }
			if disable_filetypes[vim.bo[bufnr].filetype] then
				return nil
			else
				return {
					timeout_ms = 500,
					lsp_format = "fallback",
				}
			end
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			markdown = { "prettier" },
			javascript = js_formatters,
			javascriptreact = js_formatters,
			typescript = js_formatters,
			typescriptreact = js_formatters,
			css = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			yaml = { "prettier" },
		},
	},
}
