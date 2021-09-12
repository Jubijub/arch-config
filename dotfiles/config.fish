if status is-interactive
    # Base configuration
    ## Base PATH 
    fish_add_path -p /usr/local/bin /usr/bin /usr/local/sbin

    ## Core env variables
    set -gx LANG en_US.UTF-8
    set -gx EDITOR vim

    ## Gruvbox theme
    set brorange d65d0e
    set orange af3a03

    set fish_color_autosuggestion brblack
    set fish_color_command brcyan
    set fish_color_comment white
    set fish_color_end $orange --bold
    set fish_color_error brred
    set fish_color_keyword brblue --bold
    set fish_color_operator $brorange --bold
    set fish_color_param bryellow
    set fish_color_quote brgreen
    set fish_color_redirection magenta
    

    # bat
    alias bat "bat --theme=gruvbox-dark"

    # Conda
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    eval /home/jubi/anaconda3/bin/conda "shell.fish" "hook" $argv | source
    # <<< conda initialize <<<

    # CUDA
    set --path -gxa LD_LIBRARY_PATH /opt/cuda/lib64

    # exa
    alias la "exa --header --long --all --icons "
    alias lg "exa --header --long --all --icons --git"

    # fzf.fish
    set fzf_preview_file_cmd bat --theme=gruvbox-dark

    # Java
    fish_add_path -a /usr/lib/jvm/default/bin 
    set -gx JDK_HOME /usr/lib/jvm/default/
    set -gx JAVA_HOME /usr/lib/jvm/default/

    # GPG agent
    set -x GPG_TTY (tty)
    set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent

    # Perl
    fish_add_path -a /usr/bin/site_perl /usr/bin/vendor_perl /usr/bin/core_perl

    # Python
    ## Shell completion for pipenv
    eval (pipenv --completion)
    ## Ensures all virtualenvs are created in this folder
    set -x WORKON_HOME /data/Projects/.virtualenvs
end

