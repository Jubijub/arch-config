-- blink.cmp replaces nvim-cmp + cmp-nvim-lsp/buffer/emoji/path/signature-help +
-- lspkind + LuaSnip/cmp_luasnip. colorful-menu.nvim colorizes the completion
-- label by treesitter/semantic tokens.

require("colorful-menu").setup({})

require("blink.cmp").setup({
    -- Keep the old nvim-cmp keybindings.
    keymap = {
        preset = "none",
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-y>"] = { "accept" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
    },

    appearance = { nerd_font_variant = "mono" },

    -- No LuaSnip: blink's built-in snippet source handles LSP-provided snippets.
    snippets = { preset = "default" },

    sources = {
        default = { "lsp", "path", "buffer" },
    },

    signature = { enabled = true }, -- replaces cmp-nvim-lsp-signature-help

    completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        menu = {
            draw = {
                columns = { { "kind_icon" }, { "label", gap = 1 } },
                components = {
                    label = {
                        text = function(ctx)
                            return require("colorful-menu").blink_components_text(ctx)
                        end,
                        highlight = function(ctx)
                            return require("colorful-menu").blink_components_highlight(ctx)
                        end,
                    },
                },
            },
        },
    },
})
