require("dapui").setup()

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

vim.keymap.set("n", "<F6>", dap.step_over)
