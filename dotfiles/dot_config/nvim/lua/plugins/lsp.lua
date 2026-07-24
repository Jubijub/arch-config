-- LSP without mason. Servers are installed on the system (see wiki 09):
--   lua-language-server, ruff, ty
-- nvim-lspconfig ships the base configs (cmd / filetypes / root_markers); we
-- override a few fields and turn servers on with the built-in vim.lsp API.

-- Completion capabilities advertised by blink.cmp, for every server.
vim.lsp.config("*", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
})

-- Ruff: fast linter/formatter LSP.
vim.lsp.config("ruff", {
    init_options = { settings = { logLevel = "debug" } },
})

-- ty: Astral's Python type checker (LSP). lspconfig may not ship a config yet,
-- so give the command explicitly.
vim.lsp.config("ty", {
    cmd = { "ty", "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "ty.toml", ".git" },
})

vim.lsp.config("lua_ls", {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
                return
            end
        end
        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            diagnostics = { globals = { "vim" } },
            runtime = { version = "LuaJIT" },
            workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
            },
        })
    end,
    settings = { Lua = {} },
})

vim.lsp.enable({ "lua_ls", "ruff", "ty" })

-- Defer hover to ty rather than ruff.
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_disable_ruff_hover", { clear = true }),
    desc = "Disable Ruff hover in favor of ty",
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
        end
    end,
})

-- LSP keymaps, set once a server attaches to a buffer.
vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function(event)
        local opts = { buffer = event.buf }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<C-h>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>ds", vim.lsp.buf.document_symbol, opts)
        vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
        end, opts)
        vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "]d", function()
            vim.diagnostic.jump({ count = 1, float = true })
        end, opts)
        vim.keymap.set("n", "[d", function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, opts)
        vim.keymap.set("n", "<leader>dd", "<cmd>Telescope diagnostics<CR>", opts)
    end,
})

-- Highlight the word under the cursor via LSP document highlight (this replaces
-- vim-illuminate). Catppuccin themes the LspReference* groups already.
vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP document highlight",
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client or not client:supports_method("textDocument/documentHighlight") then
            return
        end
        local group = vim.api.nvim_create_augroup("lsp_doc_highlight_" .. event.buf, { clear = true })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = group,
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = group,
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
        })
    end,
})
