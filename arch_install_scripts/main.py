from arch_configurator.steps import InstallStep, DotfileStep, ManualStep, Step
from arch_configurator.tui import InstallerApp

STEPS: list[Step] = [
    ## Tmux
    InstallStep("tmux", name="Tmux"),
    DotfileStep("home/jubi/.config/tmux/tmux.conf", name="Tmux config"),
    ManualStep(
        title="Install Tmux plugins",
        instruction="- Launch Tmux\n- Press `CTRL+SPACE`, then `I` (capital I) to install plugins",
    ),
    InstallStep("tmux-plugin-manager", name="Tmux Plugin Manager"),
    ## Neovim
    InstallStep("neovim wl-clipboard npm ripgrep tree-sitter-cli", name="Neovim + dependencies"),
    DotfileStep("home/jubi/.config/nvim/init.lua", name="Neovim: init"),
    DotfileStep("home/jubi/.config/nvim/lua/jubi/remap.lua", name="Neovim: remaps"),
    DotfileStep("home/jubi/.config/nvim/lua/jubi/set.lua", name="Neovim: settings"),
    DotfileStep("home/jubi/.config/nvim/lua/jubi/init.lua", name="Neovim: jubi init"),
    ### Neovim plugins declaration
    DotfileStep("home/jubi/.config/nvim/lua/jubi/config/lazy.lua", name="Neovim: Lazy.nvim config"),
    DotfileStep("home/jubi/.config/nvim/lua/jubi/plugins/catppuccin.lua", name="Neovim: Catppuccin plugin"),
    DotfileStep("home/jubi/.config/nvim/lua/jubi/plugins/conform-nvim.lua", name="Neovim: Conform plugin"),
    DotfileStep("home/jubi/.config/nvim/lua/jubi/plugins/gitsigns.lua", name="Neovim: Gitsigns plugin"),
    DotfileStep("home/jubi/.config/nvim/lua/jubi/plugins/harpoon.lua", name="Neovim: Harpoon plugin"),
    DotfileStep("home/jubi/.config/nvim/lua/jubi/plugins/lualine.lua", name="Neovim: Lualine plugin"),
    DotfileStep("home/jubi/.config/nvim/lua/jubi/plugins/mason.lua", name="Neovim: Mason plugin"),
    DotfileStep("home/jubi/.config/nvim/lua/jubi/plugins/nvim-cmp.lua", name="Neovim: nvim-cmp plugin"),
    DotfileStep("home/jubi/.config/nvim/lua/jubi/plugins/nvim-dap.lua", name="Neovim: nvim-dap plugin"),
    DotfileStep("home/jubi/.config/nvim/lua/jubi/plugins/nvim-lspconfig.lua", name="Neovim: LSP config plugin"),
    DotfileStep("home/jubi/.config/nvim/lua/jubi/plugins/telescope-fzf-native.lua", name="Neovim: Telescope fzf plugin"),
    DotfileStep("home/jubi/.config/nvim/lua/jubi/plugins/telescope.lua", name="Neovim: Telescope plugin"),
    DotfileStep("home/jubi/.config/nvim/lua/jubi/plugins/treesitter.lua", name="Neovim: Treesitter plugin"),
    DotfileStep("home/jubi/.config/nvim/lua/jubi/plugins/undotree.lua", name="Neovim: Undotree plugin"),
    DotfileStep("home/jubi/.config/nvim/lua/jubi/plugins/vim-commentary.lua", name="Neovim: vim-commentary plugin"),
    DotfileStep("home/jubi/.config/nvim/lua/jubi/plugins/vim-illuminate.lua", name="Neovim: vim-illuminate plugin"),
    ### Neovim /after configurations
    DotfileStep("home/jubi/.config/nvim/after/plugin/conform-nvim.lua", name="Neovim: Conform plugin config"),
    DotfileStep("home/jubi/.config/nvim/after/plugin/gitsigns.lua", name="Neovim: Gitsigns plugin config"),
    DotfileStep("home/jubi/.config/nvim/after/plugin/harpoon.lua", name="Neovim: Harpoon plugin config"),
    DotfileStep("home/jubi/.config/nvim/after/plugin/lspconfig_meta.lua", name="Neovim: LSP config plugin config"),
    DotfileStep("home/jubi/.config/nvim/after/plugin/lualine.lua", name="Neovim: Lualine plugin config"),
    DotfileStep("home/jubi/.config/nvim/after/plugin/nvim-dap.lua", name="Neovim: nvim-dap plugin config"),
    DotfileStep("home/jubi/.config/nvim/after/plugin/telescope.lua", name="Neovim: Telescope plugin config"),
    DotfileStep("home/jubi/.config/nvim/after/plugin/undotree.lua", name="Neovim: Undotree plugin config"),
    DotfileStep("home/jubi/.config/nvim/after/plugin/vim-illuminate.lua", name="Neovim: vim-illuminate plugin config"),
    ManualStep(
        title="Install Neovim plugins",
        instruction="- Launch `nvim`\n- Run `:Lazy` then press `U` to update plugins\n- Run `:Mason` and install `ty`",
    ),
]


def main() -> None:
    InstallerApp(STEPS).run()


if __name__ == "__main__":
    main()
