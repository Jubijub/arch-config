#Enable Docker completion
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i
kitty + complete setup zsh | source /dev/stdin

#Enable colors
eval $( dircolors -b $HOME/.LS_COLORS )

#Enables history saving
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory

#Enable syntax highlighting
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

#POWERLEVEL9K config
#Note : color are meant to be used with a Terminal using One Dark color scheme
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir dir_writable vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time status virtualenv anaconda docker_machine battery time)
POWERLEVEL9K_DIR_HOME_BACKGROUND="237"
POWERLEVEL9K_DIR_HOME_FOREGROUND="006"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="237"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="004"
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="237"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="009"
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_VCS_CLEAN_BACKGROUND='002'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='003'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='001'

source /usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme

#aliases
alias ls="ls --color"
alias la="ls -la"
alias ll="ls -ll"
alias less="less -R"
