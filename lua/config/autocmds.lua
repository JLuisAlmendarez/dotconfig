vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python", "lua", "bash", "markdown", "vim" },
	callback = function()
		vim.treesitter.start()
	end,
})
