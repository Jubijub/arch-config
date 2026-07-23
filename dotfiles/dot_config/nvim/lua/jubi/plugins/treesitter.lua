return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
        require('nvim-treesitter.install').install({
            "bash", "c", "cpp", "dockerfile", "fish", "git_config", "git_rebase",
            "gitcommit", "gitignore", "json", "lua", "markdown", "markdown_inline",
            "python", "query", "rust", "toml", "vim", "vimdoc"
        })

        require('nvim-treesitter-textobjects').setup {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                    ["al"] = "@loop.outer",
                    ["il"] = "@loop.inner",
                },
                include_surrounding_whitespace = true,
            },
        }
    end
}
