return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
    },
    build = ":MasonUpdate" -- :MasonUpdate updates registry contents
}
