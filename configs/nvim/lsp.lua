local mason_lsp = require("mason-lspconfig")
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")
local mason_tool_installer = require("mason-tool-installer")

require("neodev").setup({})

mason_lsp.setup({
	ensure_installed = {
		"lua_ls",
		"cssls",
		"eslint",
		"html",
		"jsonls",
		"tsserver",
		"tailwindcss",
		"volar",
	},
})

mason_tool_installer.setup({
	ensure_installed = {
		"prettier",
		"stylua",
		"nixpkgs-fmt",
	},
})

mason_lsp.setup_handlers({
	function(server_name)
		lspconfig[server_name].setup({
			capabilities = lsp_capabilities,
		})
	end,

	["lua_ls"] = function()
		lspconfig.lua_ls.setup({
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})
	end,
})
