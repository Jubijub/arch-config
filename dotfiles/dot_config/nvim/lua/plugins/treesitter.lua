-- nvim-treesitter MAIN branch (the 0.11+ rewrite). Differences from the old
-- `master` branch:
--   * parsers are compiled with the `tree-sitter` CLI (pacman: tree-sitter-cli),
--   * there is no `configs.setup{ highlight = { enable = true } }`; you opt into
--     highlighting yourself per buffer with `vim.treesitter.start()`.

require("nvim-treesitter").install({
    "bash", "c", "cpp", "dockerfile", "fish", "git_config", "git_rebase",
    "gitcommit", "gitignore", "json", "lua", "markdown", "markdown_inline",
    "python", "query", "rust", "toml", "vim", "vimdoc",
})

-- Start treesitter highlighting for any buffer that has a parser installed.
vim.api.nvim_create_autocmd("FileType", {
    desc = "Enable treesitter highlighting",
    callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
    end,
})

require("nvim-treesitter-textobjects").setup({
    select = {
        lookahead = true,
        include_surrounding_whitespace = true,
    },
})

local select = require("nvim-treesitter-textobjects.select").select_textobject
for lhs, obj in pairs({
    ["af"] = "@function.outer",
    ["if"] = "@function.inner",
    ["ac"] = "@class.outer",
    ["ic"] = "@class.inner",
    ["al"] = "@loop.outer",
    ["il"] = "@loop.inner",
}) do
    vim.keymap.set({ "x", "o" }, lhs, function()
        select(obj, "textobjects")
    end)
end
