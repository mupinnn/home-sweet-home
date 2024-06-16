local conform = require("conform")

local formatters = {
	lua = { "stylua" },
	nix = { "nixpkgs_fmt" },
}

local ft_using_prettier = {
	"astro",
	"css",
	"scss",
	"sass",
	"html",
	"json",
	"javascript",
	"javascriptreact",
	"markdown",
	"typescript",
	"typescriptreact",
	"vue",
	"yaml",
}

for _, filetype in pairs(ft_using_prettier) do
	formatters[filetype] = { "prettier" }
end

conform.setup({
	formatters_by_ft = formatters,
	format_on_save = {
		lsp_fallback = true,
		async = false,
		timeout_ms = 1000,
	},
})

vim.keymap.set({ "n", "v" }, "<leader>mp", function()
	conform.format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 1000,
	})
end, { desc = "Format file or range (in visual mode)" })
