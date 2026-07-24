-- Plugin manager: Neovim 0.12 built-in vim.pack (replaces lazy.nvim).
-- vim.pack.add installs any missing plugins synchronously and loads them, so the
-- require()s below can configure them straight away.

vim.pack.add({
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },

    -- LSP + completion
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1") },
    { src = "https://github.com/xzbdmw/colorful-menu.nvim" },

    -- Treesitter (main branch = the 0.11+ rewrite; needs the `tree-sitter` CLI)
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },

    -- Fuzzy finder
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },

    -- Git
    { src = "https://github.com/lewis6991/gitsigns.nvim" },

    -- Debugging
    { src = "https://github.com/mfussenegger/nvim-dap" },
    { src = "https://github.com/rcarriga/nvim-dap-ui" },
    { src = "https://github.com/nvim-neotest/nvim-nio" },
    { src = "https://github.com/mfussenegger/nvim-dap-python" },

    -- UI
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/echasnovski/mini.icons" },

    -- Editing / navigation
    { src = "https://github.com/mbbill/undotree" },
    { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
    { src = "https://github.com/stevearc/conform.nvim" },
})

-- Mason only on non-Arch systems (Windows, Debian). On Arch the servers come
-- from pacman/uv, so Mason and its plugins are not even installed.
if not require("platform").is_arch then
    vim.pack.add({
        { src = "https://github.com/mason-org/mason.nvim" },
        { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
    })
end

-- Build steps. vim.pack fires PackChanged on install/update/delete.
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local d = ev.data
        if d.kind == "delete" then
            return
        end
        if d.spec.name == "telescope-fzf-native.nvim" then
            vim.notify("[pack] building telescope-fzf-native", vim.log.levels.INFO)
            vim.system({ "make" }, { cwd = d.path }):wait()
        elseif d.spec.name == "nvim-treesitter" then
            pcall(function()
                require("nvim-treesitter").update()
            end)
        end
    end,
})

-- Configure. Order matters: icons mock before statusline/telescope; colorscheme early.
require("plugins.icons")
require("plugins.colorscheme")
require("plugins.treesitter")
require("plugins.lsp")
require("plugins.completion")
require("plugins.telescope")
require("plugins.git")
require("plugins.dap")
require("plugins.statusline")
require("plugins.editing")
