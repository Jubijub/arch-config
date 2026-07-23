# Path
typeset -U path
path=(
    $HOME/.local/bin
    $path[@])

# XDG Base directories
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
: "${XDG_DATA_DIRS:=/usr/local/share:/usr/share}"
export XDG_DATA_DIRS

# Core env variables
export EDITOR=nvim
