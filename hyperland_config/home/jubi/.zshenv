# Path
typeset -U path
path=( 
    $HOME/.pyenv
    $HOME/.local/bin
    $HOME/.npm-packages/bin
    /opt/cuda/bin
    /usr/local/bin
    /usr/bin
    /bin
    $path[@])
# XDG Base directories
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_DATA_DIRS=/usr/local/share:/usr/share:$XDG_DATA_DIRS

# Environment variables
export EDITOR=nvim
export GTK_THEME="Catppuccin-Dark"
export JAVA_HOME=/usr/lib/jvm/default/
export JDK_HOME=/usr/lib/jvm/default/
export LANG=en_US.UTF-8
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/opt/cuda/lib64
export MAKEFLAGS="-j8 -l8"
export PYENV_ROOT="$HOME/.pyenv"

# Set SSH to use gpg-agent
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi 

# Set GPG TTY
export GPG_TTY=$(tty)

# fzf
export FZF_DEFAULT_OPTS="--height 20% --border \
	--preview 'bat --style=numbers --color=always --line-range :500 {}' \
	--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
     	--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
     	--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

#Man pages colorized with bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
