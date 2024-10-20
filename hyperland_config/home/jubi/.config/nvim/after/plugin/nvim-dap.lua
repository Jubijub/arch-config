require("dapui").setup()
require("dap-python").setup()

local dap, dapui = require("dap"), require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

local sign = vim.fn.sign_define


local mason_registry = require("mason-registry")
local codelldb = mason_registry.get_package("codelldb")
local codelldb_root = codelldb:get_install_path() .. "/extension/"
local codelldb_path = codelldb_root .. "adapter/codelldb"
local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"

dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {
        -- CHANGE THIS to your path!
        command = codelldb_path,
        args = { "--port", "${port}" },
    }
}

dap.configurations.rust = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        -- program = function()
        --     return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        -- end,
        program = codelldb_path,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    },
}

-- These are to override the default highlight groups for catppuccin (see https://github.com/catppuccin/nvim/#special-integrations)
sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })


vim.keymap.set("n", "<F9>", ':DapToggleBreakpoint<CR>')
vim.keymap.set("n", "<s-F5>", ':DapTerminate<CR>')
vim.keymap.set("n", "<F5>", ':DapContinue<CR>')
vim.keymap.set("n", "<F10>", ':DapStepOver<CR>')
vim.keymap.set("n", "<F11>", ':DapStepInto<CR>')
vim.keymap.set("n", "<s-F11>", ':DapStepOut<CR>')
