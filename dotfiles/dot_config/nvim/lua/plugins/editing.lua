-- Harpoon (quick file navigation) -------------------------------------------
local harpoon = require("harpoon")
harpoon:setup()

-- Show the harpoon list through a telescope picker.
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end
    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({ results = file_paths }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

vim.keymap.set("n", "<C-t>", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>ja", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>js", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>jd", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>jf", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<C-s>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-d>", function() harpoon:list():next() end)

-- Undotree -------------------------------------------------------------------
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- conform.nvim (formatting) --------------------------------------------------
require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format", "ruff_organize_imports" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        rust = { "rustfmt", lsp_format = "fallback" },
    },
    format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
    },
})
