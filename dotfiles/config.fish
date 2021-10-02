if status is-interactive
    # Base configuration
    ## Base PATH 
    fish_add_path -p /usr/local/bin /usr/bin /usr/local/sbin

    ## Core env variables
    set -gx LANG en_US.UTF-8
    set -gx EDITOR vim

    ## Monokai Pro theme
    set fish_color_autosuggestion brblack
    set fish_color_command brgreen
    set fish_color_comment white
    set fish_color_error brred
    set fish_color_keyword brblue --bold
    set fish_color_operator brred --bold
    set fish_color_param magenta
    set fish_color_quote brgreen
    set fish_color_redirection magenta
    set fish_color_valid_path white --underline
    

    # bat
    alias bat "bat --theme=TwoDark"

    # CUDA
    set --path -gxa LD_LIBRARY_PATH /opt/cuda/lib64

    # exa
    alias la "exa --header --long --all --icons "
    alias lg "exa --header --long --all --icons --git"

    # fzf.fish
    set fzf_preview_file_cmd bat --theme=TwoDark

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

