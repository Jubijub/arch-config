# Path
typeset -U path
path=( 
    /bin
    /usr/bin
    /usr/local/bin
    /usr/lib/ccache/bin
    /opt/cuda/bin
    $HOME/.npm-packages/bin
    $path[@])

# Environment variables
export LANG=en_US.UTF-8
export EDITOR=vim
export MAKEFLAGS="-j8 -l8"
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/opt/cuda/lib64
export JDK_HOME=/usr/lib/jvm/default/
export JAVA_HOME=/usr/lib/jvm/default/

# Set SSH to use gpg-agent
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

# Set GPG TTY
export GPG_TTY=$(tty)

# fzf
export FZF_DEFAULT_OPTS='--height 20% --border'