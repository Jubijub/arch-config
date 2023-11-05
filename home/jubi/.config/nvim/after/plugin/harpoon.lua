local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-t>", ui.toggle_quick_menu)

vim.keymap.set("n", "<leader>ja", function() ui.nav_file(1) end)
vim.keymap.set("n", "<leader>js", function() ui.nav_file(2) end)
vim.keymap.set("n", "<leader>jd", function() ui.nav_file(3) end)
vim.keymap.set("n", "<leader>jf", function() ui.nav_file(4) end)
