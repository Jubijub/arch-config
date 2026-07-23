###################################################################################################
# ZSH basic configuration
#
# Zsh is only kept as a POSIX-ish fallback, for the rare cases where Fish does not
# fit. It is deliberately plugin-free : Fish is the real shell, see config.fish.
###################################################################################################

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
# Command line tools
###################################################################################################

#aliases
alias eza="eza --time-style=long-iso"
alias ls="eza"
alias la="ls --long --all --header --icons"
alias lg="ls --long --all --header --icons --git"
alias less="less -R"
alias fd="fd -HI"

# LS_COLORS : Catppuccin Mocha, used by eza, fd and ls
if command -v vivid >/dev/null; then
    export LS_COLORS="$(vivid generate catppuccin-mocha)"
fi

# fzf : Catppuccin Mocha theme
export FZF_DEFAULT_OPTS="--height 20% --border \
    --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
    --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
    --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
    --color=selected-bg:#45475A \
    --color=border:#6C7086,label:#CDD6F4"

#fzf key bindings, shipped by the fzf package itself (not a plugin)
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

#Starship.rs
eval "$(starship init zsh)"
