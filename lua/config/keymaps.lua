local keymap = vim.keymap.set
vim.g.mapleader = " "

keymap("n", "<leader>w", ":w<CR>", { desc = "Guardar archivo" })
keymap("n", "<leader>q", ":q<CR>", { desc = "Salir" })
keymap("n", "<leader>e", ":Explore<CR>", { desc = "Explorador de archivos" })
keymap("n", "<leader>e", ":Oil<CR>", { desc = "Explorador de archivos (Oil)" })

local builtin = require("telescope.builtin")

keymap("n", "<leader>ff", builtin.find_files, { desc = "Buscar archivos" })
keymap("n", "<leader>fg", builtin.live_grep, { desc = "Buscar texto en archivos" })
keymap("n", "<leader>fb", builtin.buffers, { desc = "Buscar buffers abiertos" })
