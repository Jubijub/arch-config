require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { 
        "bashls", 
        "cssls", 
        "dockerls", 
        "html", 
        "jsonls",
        "lua_ls",
        "pylsp", 
        "sqlls", 
        "tsserver", 
        "yamlls" 
    },
}
