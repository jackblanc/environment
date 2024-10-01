require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map("t", "<ESC>", "<C-\\><C-n>", { noremap = true })

-- Map Command + S to save file
map({ "n", "i", "v" }, "<D-s>", "<cmd>w<CR>", { noremap = true, silent = true })
