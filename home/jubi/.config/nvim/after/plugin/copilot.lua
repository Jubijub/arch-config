require('copilot').setup({
    panel = {
        enabled = false
    },
    suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
            accept = "<M-y>",
            accept_line = "<M-u>",
            accept_word = "<M-i>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
        }
    }
})
