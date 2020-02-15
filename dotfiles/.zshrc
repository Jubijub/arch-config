###################################################################################################
# ZSH basic configuration
###################################################################################################
#Enable Docker completion
fpath=(~/.zsh/completion $fpath)

#Autocompletion
zstyle ':completion:*' menu yes select
zstyle ':completion::complete:*' use-cache 1                    #enables completion caching
zstyle ':completion::complete:*' cache-path ~/.zsh/cache
autoload -Uz compinit && compinit -i

#to know the key binding for a key, run `od -c` and press the key
bindkey '^[[3~' delete-char                           #enables DEL key proper behaviour
bindkey '^[[1;5C' forward-word                        #[Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word                       #[Ctrl-LeftArrow] - move backward one word
bindkey  "^[[H"   beginning-of-line                   #[Home] - goes at the begining of the line
bindkey  "^[[F"   end-of-line                         #[End] - goes at the end of the line

#Enables history saving
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt share_history        #share history between multiple instances of zsh

###################################################################################################
# Plugins
###################################################################################################
#Enable syntax highlighting
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

#Enable Fish-like auto-suggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh 

#kitty config
kitty + complete setup zsh | source /dev/stdin

#fzf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

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

#Enable differentiated colors depending on file types
eval $( dircolors -b $HOME/.LS_COLORS )

#aliases
alias ls="ls --color"
alias la="ls -la"
alias ll="ls -ll"
alias less="less -R"

# Refresh gpg-agent tty in case user switches into an X session
gpg-connect-agent updatestartuptty /bye >/dev/null
