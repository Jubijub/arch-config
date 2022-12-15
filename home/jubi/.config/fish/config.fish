if status is-interactive
    fish_add_path -p $HOME/.local/bin # for PyPoetry
    fish_add_path $HOME/.pyenv # for PyEnv
    fish_add_path -p /opt/cuda/bin
    fish_add_path -p /usr/local/sbin /usr/local/bin /usr/bin /bin

    
    # XDG Base directories
    set -gx XDG_CONFIG_HOME $HOME/.config
    set -gx XDG_DATA_HOME $HOME/.local/share
    set -gx XDG_DATA_DIRS /usr/local/share:/usr/share:$XDG_DATA_DIRS    

    ## Core env variables
    set -gx EDITOR vim
    set -Ux GTK_THEME "Catppuccin-Macchiato"
    set -gx LANG en_US.UTF-8
    
    # CUDA
    set -gx LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/cuda/lib64

    # exa
    alias exa="exa --time-style=long-iso"
    alias ls="exa"
    alias la="ls --long --all --header --icons"
    alias lg="ls --long --all --header --icons --git"
    alias less="less -R"

    #fd
    alias fd="fd -HI"
    
    # fzf
    set -Ux FZF_DEFAULT_OPTS "\
    --height 20% --border \
    --preview 'bat --style=numbers --color=always --line-range :500 {}' \
    --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
    --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
    --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

    # Java
    set -gx JDK_HOME /usr/lib/jvm/default/
    set -gx JAVA_HOME /usr/lib/jvm/default/

    # GPG agent
    set -x GPG_TTY (tty)
    set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent

    # Perl
    fish_add_path -a /usr/bin/site_perl /usr/bin/vendor_perl /usr/bin/core_perl

    #Pyenv
    set -Ux PYENV_ROOT $HOME/.pyenv
    pyenv init - | source

    #Starship.rs
    starship init fish | source
end
