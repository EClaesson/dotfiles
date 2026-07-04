return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"mason-org/mason.nvim",
			opts = {},
		},
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"b0o/schemastore.nvim",
		{
			"j-hui/fidget.nvim",
			opts = {},
		},
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				map("<leader>cn", vim.lsp.buf.rename, "Re[n]ame")
				local ca = vim.fn.maparg("<leader>ca", "n", false, true)
				if vim.tbl_isempty(ca) or ca.buffer ~= 1 then
					map("<leader>ca", vim.lsp.buf.code_action, "Code [A]ction", { "n", "x" })
				end
				map("<leader>cd", function()
					require("telescope.builtin").lsp_definitions()
				end, "Goto [D]efinition")
				map("<leader>cD", vim.lsp.buf.declaration, "Goto [D]eclaration")
				map("<leader>cr", function()
					require("telescope.builtin").lsp_references()
				end, "Goto [R]eferences")
				map("<leader>ci", function()
					require("telescope.builtin").lsp_implementations()
				end, "Goto [I]mplementation")
				map("<leader>cy", function()
					require("telescope.builtin").lsp_type_definitions()
				end, "Goto T[y]pe Definition")
				map("<leader>cS", function()
					require("telescope.builtin").lsp_document_symbols()
				end, "Document [S]ymbols")
				map("<leader>cw", function()
					require("telescope.builtin").lsp_dynamic_workspace_symbols()
				end, "[W]orkspace Symbols")

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client:supports_method("textDocument/documentHighlight", event.buf) then
					local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				if client and client:supports_method("textDocument/inlayHint", event.buf) then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "Toggle Inlay [H]ints")
				end
			end,
		})

		local servers = {
			bashls = {},
			clangd = {},
			docker_compose_language_service = {},
			docker_language_server = {},
			elixirls = {},
			eslint = {
				settings = {
					workingDirectory = {
						mode = "auto",
					},
				},
				root_dir = require("lspconfig.util").root_pattern(
					"eslint.config.js",
					"eslint.config.mjs",
					"eslint.config.cjs",
					".eslintrc",
					".eslintrc.js",
					".eslintrc.cjs",
					".eslintrc.json",
					"eslint.config.ts",
					"package.json"
				),
			},
			gopls = {},
			html = {},
			cssls = {},
			tailwindcss = {},
			svelte = {},
			astro = {},
			jsonls = {
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			},
			postgres_lsp = {},
			pyright = {},
			taplo = {},
			tofu_ls = {},
			vtsls = {},
			yamlls = {
				settings = {
					yaml = {
						schemaStore = { enable = false, url = "" },
						schemas = require("schemastore").yaml.schemas(),
					},
				},
			},

			lua_ls = {
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if
							path ~= vim.fn.stdpath("config")
							and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
						then
							return
						end
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							version = "LuaJIT",
							path = { "lua/?.lua", "lua/?/init.lua" },
						},
						workspace = {
							checkThirdParty = false,
							library = vim.tbl_extend("force", vim.api.nvim_get_runtime_file("", true), {
								"${3rd}/luv/library",
								"${3rd}/busted/library",
							}),
						},
					})
				end,
				settings = {
					Lua = {},
				},
			},
		}

		local tools = {
			"delve",
			"gofumpt",
			"goimports",
			"golangci-lint",
			"gomodifytags",
			"gotests",
			"gotestsum",
			"iferr",
			"impl",
			"json-to-struct",
			"prettier",
			"eslint_d",
			"stylua",
		}

		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, tools)

		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			once = true,
			callback = function()
				require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			end,
		})

		for name, server in pairs(servers) do
			vim.lsp.config(name, server)
			vim.lsp.enable(name)
		end
	end,
}
