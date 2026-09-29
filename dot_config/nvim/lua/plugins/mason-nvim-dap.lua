return {
	"jay-babu/mason-nvim-dap.nvim",
	lazy = true,
	dependencies = { "mason-org/mason.nvim" },
	opts = {
		handlers = {
			js = function()
				local dap = require("dap")
				dap.adapters["pwa-node"] = {
					type = "server",
					host = "localhost",
					port = "${port}",
					executable = {
						command = "js-debug-adapter",
						args = { "${port}" },
					},
				}
				for _, filetype in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
					dap.configurations[filetype] = {
						{
							type = "pwa-node",
							request = "launch",
							name = "Launch file",
							program = "${file}",
							cwd = "${workspaceFolder}",
						},
						{
							type = "pwa-node",
							request = "attach",
							name = "Attach to process",
							processId = require("dap.utils").pick_process,
							cwd = "${workspaceFolder}",
						},
					}
				end
			end,
		},
		ensure_installed = { "python", "js" },
	},
}
