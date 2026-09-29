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
		"saghen/blink.cmp",
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
					vim.b[event.buf].minicursorword_disable = true
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
							vim.b[event2.buf].minicursorword_disable = nil
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
			eslint = {},
			gopls = {},
			html = {},
			cssls = {},
			tailwindcss = {},
			svelte = {},
			astro = {},
			jsonls = {
				before_init = function(_, config)
					config.settings.json.schemas = require("schemastore").json.schemas()
				end,
				settings = {
					json = {
						schemas = {},
						validate = { enable = true },
					},
				},
			},
			postgres_lsp = {},
			pyright = {
				before_init = function(_, config)
					local python = config.root_dir and vim.fs.joinpath(config.root_dir, ".venv", "bin", "python")
					if python and vim.uv.fs_stat(python) then
						config.settings.python = vim.tbl_deep_extend("force", config.settings.python or {}, {
							pythonPath = python,
						})
					end
				end,
			},
			ruff = {
				on_attach = function(client)
					client.server_capabilities.hoverProvider = false
				end,
			},
			taplo = {},
			tofu_ls = {},
			vtsls = {
				settings = (function()
					local inlay_hints = {
						parameterNames = { enabled = "literals" },
						parameterTypes = { enabled = true },
						variableTypes = { enabled = false },
						propertyDeclarationTypes = { enabled = true },
						functionLikeReturnTypes = { enabled = true },
						enumMemberValues = { enabled = true },
					}
					return {
						typescript = { inlayHints = inlay_hints },
						javascript = { inlayHints = inlay_hints },
					}
				end)(),
			},
			yamlls = {
				-- The CloudFormation/SAM schemas only know the long intrinsic form ({ "Fn::Join": ... }),
				-- so short-form tags like `!Join [...]` produce false "Incorrect type" errors.
				handlers = {
					["textDocument/publishDiagnostics"] = function(err, result, ctx)
						local bufnr = vim.uri_to_bufnr(result.uri)
						result.diagnostics = vim.tbl_filter(function(d)
							if not vim.startswith(d.message, "Incorrect type.") then
								return true
							end
							local line = vim.api.nvim_buf_get_lines(bufnr, d.range.start.line, d.range.start.line + 1, false)[1]
							return not (line and line:find("!%u%a*"))
						end, result.diagnostics)
						vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
					end,
				},
				before_init = function(_, config)
					config.settings.yaml.schemas = require("schemastore").yaml.schemas()
				end,
				settings = {
					yaml = {
						schemaStore = { enable = false, url = "" },
						schemas = {},
						customTags = {
							"!And sequence",
							"!Base64 scalar",
							"!Base64 mapping",
							"!Cidr sequence",
							"!Condition scalar",
							"!Equals sequence",
							"!FindInMap sequence",
							"!GetAtt scalar",
							"!GetAtt sequence",
							"!GetAZs scalar",
							"!GetAZs mapping",
							"!If sequence",
							"!ImportValue scalar",
							"!ImportValue mapping",
							"!Join sequence",
							"!Length sequence",
							"!Not sequence",
							"!Or sequence",
							"!Ref scalar",
							"!Select sequence",
							"!Split sequence",
							"!Sub scalar",
							"!Sub sequence",
							"!ToJsonString mapping",
							"!ToJsonString sequence",
							"!Transform mapping",
						},
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
							library = vim.list_extend(vim.api.nvim_get_runtime_file("", true), {
								"${3rd}/luv/library",
								"${3rd}/busted/library",
							}),
						},
					})
				end,
				settings = {
					Lua = {
						hint = { enable = true },
					},
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
			"yamllint",
			"cfn-lint",
			"shellcheck",
			"shfmt",
			"sql-formatter",
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
