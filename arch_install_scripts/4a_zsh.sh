#!/usr/bin/env zsh

archASCII='
         \e[0;36m.
        \e[0;36m/ \
       \e[0;36m/   \    \e[1;37m         #     \e[1;36m| *
      \e[0;36m/^.   \   \e[1;37m#%" a#"e 6##%  \e[1;36m| | |-^-. |   | \ /
     \e[0;36m/  .-.  \  \e[1;37m#   #    #  #  \e[1;36m| | |   | |   |  X
    \e[0;36m/  (   ) _\ \e[1;37m#   %#e" #  #  \e[1;36m| | |   | ^._.| / \
   \e[1;36m/ _.~   ~._^\
  \e[1;36m/.^         ^.\ \e[0;37mTM\e[m'

echo -e "$archASCII"

#ZSH
cd ~/Downloads
git clone https://github.com/catppuccin/zsh-syntax-highlighting.git
cd zsh-syntax-highlighting/themes/
mkdir ~/.zsh
cp -v catppuccin_mocha-zsh-syntax-highlighting.zsh ~/.zsh/

mkdir ~/.zfunc
cd ~/.zfunc
curl -L "https://raw.githubusercontent.com/ogham/exa/master/completions/zsh/_exa" -O

#TODO: add right_format = """[ZSH](fg:red bg:#fab387)""" et have 2 scripts for starship.toml, referred to by env variable : export STARSHIP_CONFIG=~/example/non/default/path/starship.toml
#TODO: Add zsh et fish config for eza / fd / bat