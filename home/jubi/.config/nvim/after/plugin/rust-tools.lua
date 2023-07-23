local rt = require("rust-tools")
local mason_registry = require("mason-registry")
local codelldb = mason_registry.get_package("codelldb")
local codelldb_root = codelldb:get_install_path() .. "/extension/"
local codelldb_path = codelldb_root .. "adapter/codelldb"
local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"

rt.setup({
    dap = {
        adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
    },
    server = {
        on_attach = function(_, bufnr)
            -- Hover actions
            vim.keymap.set("n", "<Leader>rk", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<Leader>ra", rt.code_action_group.code_action_group, { buffer = bufnr })
        end,
    },
    tools = {
        hover_actions = {
            auto_focus = true,
        },
    },
})
