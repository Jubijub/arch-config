# XDG Base directories
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
if not set -q XDG_DATA_DIRS
    set -gx --path XDG_DATA_DIRS /usr/local/share /usr/share
end

## Core env variables
set -gx EDITOR nvim

if status is-interactive
    # eza
    alias eza="eza --time-style=long-iso"
    alias ls="eza"
    alias la="ls --long --all --header --icons"
    alias lg="ls --long --all --header --icons --git"
    alias less="less -R"

    #fd
    alias fd="fd -HI"

    # LS_COLORS : Catppuccin Mocha, used by eza, fd and ls
    if command -q vivid
        set -gx LS_COLORS (vivid generate catppuccin-mocha)
    end

    # fzf : Catppuccin Mocha theme
    set -gx FZF_DEFAULT_OPTS "\
    --height 20% --border \
    --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
    --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
    --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
    --color=selected-bg:#45475A \
    --color=border:#6C7086,label:#CDD6F4"

    # fzf.fish : bind directory search to Ctrl+T, keep the other defaults
    fzf_configure_bindings --directory=\ct

    #Starship.rs
    starship init fish | source
end
