require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format", "ruff_organize_imports" },
        javascript = { { "prettierd", "prettier" } },
        rust = { "rustfmt", lsp_format = "fallback" },
    },
    format_on_save = {
        lsp_fallback = true,
        timeout_ms = 500,
    },
})
