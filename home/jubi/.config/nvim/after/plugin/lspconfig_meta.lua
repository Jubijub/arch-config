-- This fully configures nvim-lsp, mason-lspconfig, nvim-cmp and nvim-dap

vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Keybindings
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-h>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>ds', vim.lsp.buf.document_symbol, opts)
        vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
        vim.keymap.set('n', '<leader>dl', function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
    end
})

-- Mason configuration
require("mason").setup()
require("mason-lspconfig").setup {}

-- vim lua api - must be enabled before lspconfig
require("neodev").setup({
    -- add any options here, or leave empty to use the default settings
})

local lspconfig = require('lspconfig')

-- autocomplete configuration
local cmp = require('cmp')
cmp.setup {
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
    },
    window = {
        completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = -3,
            side_padding = 0,
        },
    },
    sources = {
        { name = 'nvim_lsp' }, -- should probably be first
        { name = 'buffer' },
        { name = 'emoji' },
        { name = 'luasnip' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'path' },
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            kind.menu = "    (" .. (strings[2] or "") .. ")"

            return kind
        end,
    },
    snippet = {
        expand = function(args)
            require 'luasnip'.lsp_expand(args.body)
        end
    },
}

-- defines autocomplete categories colors using Catppuccin theme
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#6e738d", fg = "NONE" })
vim.api.nvim_set_hl(0, "Pmenu", { fg = "#CAD3F5", bg = "#181926" })

vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = "#B8C0E0", bg = "NONE", strikethrough = true })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#7DC4E4", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#7DC4E4", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#C6A0F6", bg = "NONE", italic = true })

vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = "#24273A", bg = "#ED8796" })
vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#24273A", bg = "#ED8796" })
vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = "#24273A", bg = "#ED8796" })

vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#24273A", bg = "#A6DA95" })
vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = "#24273A", bg = "#A6DA95" })
vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#24273A", bg = "#A6DA95" })

vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = "#24273A", bg = "#EED49F" })
vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { fg = "#24273A", bg = "#EED49F" })
vim.api.nvim_set_hl(0, "CmpItemKindReference", { fg = "#24273A", bg = "#EED49F" })

vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#24273A", bg = "#F5BDE6" })
vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = "#24273A", bg = "#F5BDE6" })
vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = "#24273A", bg = "#F5BDE6" })
vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = "#24273A", bg = "#F5BDE6" })
vim.api.nvim_set_hl(0, "CmpItemKindOperator", { fg = "#24273A", bg = "#F5BDE6" })

vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#24273A", bg = "#8AADF4" })
vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = "#24273A", bg = "#8AADF4" })

vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = "#24273A", bg = "#D4A959" })
vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#24273A", bg = "#D4A959" })
vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = "#24273A", bg = "#D4A959" })

vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#24273A", bg = "#91D7E3" })
vim.api.nvim_set_hl(0, "CmpItemKindValue", { fg = "#24273A", bg = "#91D7E3" })
vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { fg = "#24273A", bg = "#91D7E3" })

vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#24273A", bg = "#8BD5CA" })
vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = "#24273A", bg = "#8BD5CA" })
vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", { fg = "#24273A", bg = "#8BD5CA" })


------------------------------------------------------------------------------
-- LSP servers configuration
------------------------------------------------------------------------------

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local get_servers = require('mason-lspconfig').get_installed_servers

for _, server_name in ipairs(get_servers()) do
    lspconfig[server_name].setup({
        capabilities = lsp_capabilities,
    })
end

require('lspconfig').pylsp.setup {
    settings = {
        pylsp = {
            plugins = {
                jedi_completion = {
                    enabled = true,
                    eager = true,
                    cache_for = { "numpy", "scipy" }
                },
                jedi_definition = {
                    enabled = true,
                    follow_imports = true,
                    follow_builtin_imports = true,
                },
                jedi_hover = { enabled = true },
                jedi_references = { enabled = true },
                jedi_signature_help = { enabled = true },
                jedi_symbols = { enabled = true, all_scopes = true, include_import_symbols = true },
                preload = { enabled = true, modules = { "numpy", "scipy" } },
                isort = { enabled = false },
                spyder = { enabled = false },
                memestra = { enabled = false },
                pycodestyle = { enabled = false }, -- not work
                flake8 = { enabled = false },
                pyflakes = { enabled = false },
                yapf = { enabled = true },
                pylint = { enabled = false },
                ruff = {
                    enabled = true,
                    extendSelect = { "I" },
                },
                black = { enabled = true }
            }
        }
    }
}

require('lspconfig').htmx.setup {}

require('lspconfig').lua_ls.setup {
    on_init = function(client)
        local path = client.workspace_folders[1].name
        if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT'
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                    library = { vim.env.VIMRUNTIME }
                    -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                    -- library = vim.api.nvim_get_runtime_file("", true)
                }
            })

            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end
        return true
    end,
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace"
            }
        }
    }
}
