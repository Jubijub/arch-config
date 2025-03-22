require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = { "bash", "c", "cpp", "dockerfile", "fish", "git_config", "git_rebase", "gitcommit", "gitignore", "json", "lua", "markdown", "markdown_inline", "python", "query", "rust", "toml", "vim", "vimdoc" },

    sync_install = false,

    auto_install = true,

    highlight = {
        enable = true,

        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,

        additional_vim_regex_highlighting = false,
    },
}
