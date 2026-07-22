local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.runtimepath:append("/home/joseluisalmendarezgonzalez/.local/share/nvim/site")
vim.opt.packpath:append(vim.fn.stdpath("data") .. "/site")
vim.opt.rtp:append(vim.fn.stdpath("data") .. "/site")
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")
