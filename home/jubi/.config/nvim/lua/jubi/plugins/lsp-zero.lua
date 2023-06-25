return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
        -- LSP Support
        { 'neovim/nvim-lspconfig' }, -- Required
        {
            'williamboman/mason.nvim',
            build = function()
                pcall(vim.cmd, 'MasonUpdate')
            end,
        },
        { 'williamboman/mason-lspconfig.nvim' }, -- Optional

        -- Autocompletion
        { 'hrsh7th/nvim-cmp' }, -- Required
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
		{ 'saadparwaiz1/cmp_luasnip' },
		{ 'hrsh7th/cmp-nvim-lua' },
        { 'hrsh7th/cmp-nvim-lsp' }, -- Required
        { 'L3MON4D3/LuaSnip' }, -- Required
    }
}
