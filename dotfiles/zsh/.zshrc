export GPG_TTY=$(tty)

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

###################################################################################################
# ZSH basic configuration
###################################################################################################
#Poetry completion
fpath+=~/.zfunc # contains a completion file generated from Poetry

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

#aliases
alias exa"exa --color --time-style=long-iso"
alias ls="exa"
alias la="ls --long --all --header --icons"
alias lg="ls --long --all --header --icons --git"
alias less="less -R"
alias fd="fd -HI"

###################################################################################################
# ZSH Plugins
###################################################################################################

### Plugins installed via pacman / paru ###

#Enable syntax highlighting
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

#Enable Fish-like auto-suggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh 

#fzf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

#Powerlevel10K
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### Plugins manually installed ###
source ~/.local/share/zsh-poetry/poetry.zsh

###################################################################################################
# Tools config
###################################################################################################

#kitty config
kitty + complete setup zsh | source /dev/stdin


export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# Refresh gpg-agent tty in case user switches into an X session
gpg-connect-agent updatestartuptty /bye >/dev/null

