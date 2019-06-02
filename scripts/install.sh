#!/bin/bash

#################################################################################################################
echo "Installing whiptail"
sudo apt-get install whiptail #necessary for this script menu boxes, should be present by default on Debian / Ubuntu based distro

#################################################################################################################
# Function definitions, must be done before whiptail menu is displayed
function upgradedistribution {
    echo "Updating distribution"
    sudo apt-get -q -y update
    sudo apt-get -q -y upgrade
}

function basicsetup {
    echo "Installing aptitude and basic packages for package compilation. Initiates ~/Downloads directory."
    sudo apt-get -q -y install aptitude
    sudo aptitude -q -y install build-essential #for packages requiring build from sources

    echo "Creating $HOME/Downloads directory"
    DOWNLOADDIR=~/Downloads
    if [ ! -d "$DOWNLOADDIR" ]; then
        mkdir $DOWNLOADDIR
    fi
}

function gitsetup {
    echo "Installing Git and configuring it"
    sudo add-apt-repository -y ppa:git-core/ppa #Latest Git version
    sudo aptitude -q -y update

    sudo aptitude install git
    git config --global user.name "Julien Bidault"
    git config --global user.email jubijub@gmail.com
}

function nerdfontsetup {
    echo "Installing Powerline/Nerd fonts"

    echo "Installing fontconfig and Nerd fonts (only needed if SSHing into a server with Powerline9K theme)"
    sudo aptitude install -q -y fontconfig
    LOCALFONT=~/.local/share/fonts
    if [ ! -d "$LOCALFONT" ]; then
    mkdir -p $LOCALFONT
    cd $LOCALFONT
    # Note : ensure there is "raw" in the Github path instead of blob (just before /master)
    # Note : ensure the file name has no space
    curl -fLo "SauceCodeProNerdFontCompleteMono.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf
    curl -fLo "SauceCodeProNerdFontComplete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf
    curl -fLo "DejaVuSansMonoNerdFontCompleteMono.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono.ttf
    curl -fLo "DejaVuSansMonoNerdFontComplete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete.ttf
    curl -fLo "DroidSansMonoforPowerlineNerdFontCompleteMono.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20for%20Powerline%20Nerd%20Font%20Complete%20Mono.otf
    curl -fLo "DroidSansMonoforPowerlineNerdFontComplete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20for%20Powerline%20Nerd%20Font%20Complete.otf
    fi
    sudo fc-cache -vf ~/.local/share/fonts
}

function jekyllsetup {
    echo "Installing Ruby and basic Jekyll dependancy"
    sudo apt-add-repository -y ppa:brightbox/ruby-ng #latest Ruby version
    sudo apt-get -q -y update

    sudo aptitude -q -y install ruby2.4 ruby2.4-dev nodejs libssl-dev
    sudo gem update
    # Note : gem openssl can cause issues, solved by either installing build-essential or libssl-dev
    sudo gem install bundler
    # Note : Jekyll blog must contain a Gemfile instructing to download Github pages gem
    # This gem sets up Jekyll gems and related dependancies.
}

function zshsetup {
    echo "Installing Zsh, Oh-my-zsh and Powerline9k theme (needs Git)"

    #Zsh
    sudo aptitude -q -y install zsh
    OHMYZSHDIR=~/.oh-my-zsh
    if [ ! -d "$OHMYZSHDIR" ]; then
        /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi

    POWERLEVEL9K=~/.oh-my-zsh/custom/themes/powerlevel9k
    if [ ! -d "$POWERLEVEL9K" ]; then
        git clone https://github.com/bhilburn/powerlevel9k.git $POWERLEVEL9K
    fi

    ZSHRCFILE=~/.zshrc
    if [ -f "$ZSHRCFILE" ]; then
        rm $ZSHRCFILE
    fi
    cd ~
    curl -fLo $ZSHRCFILE https://github.com/Jubijub/linuxconfig/raw/master/config_files/.zshrc

}

function wslzshsetup {
    BASHRCFILE=~/.bashrc
    #TODO fix to make idempotent (test for the presenceof exec zsh in .bashrc before adding it again)
    cat <<EOF >> $BASHRCFILE
if [ -t 1 ]; then
    exec zsh
fi
EOF
}

#################################################################################################################
if (whiptail --title "JubiProvisioner" --yesno "This script will provision your Ubuntu linux according to the script defined on https://github.com/Jubijub/linuxconfig." 8 78) then

    whiptail --title "Provisionner menu" --checklist --separate-output "Choose:" 20 95 15 \
    "UPDATE_DITRIBUTION" "Update distribution" on \
    "BASIC_SETUP" "Install aptitude and other basic packages for compilation" on \
    "GIT_SETUP" "Install Git and configure it" on \
    "NERDFONT_SETUP" "Install Nerd fonts (only if SSHing terms with Powerline themes" on \
    "JEKYLL_SETUP" "Install Jekyll dependencies to use with GitHub pages blog" on \
    "ZSH_SETUP" "Installing Zsh, Oh-my-zsh and Powerline9k (needs git)" on \
    "WSLZSH_SETUP" "Set Zsh as default shell (Bash on Windows)" off 2>results

    while read choice
    do
        case $choice in
                UPDATE_DITRIBUTION) upgradedistribution
                ;;
                BASIC_SETUP) basicsetup
                ;;
                GIT_SETUP) gitsetup
                ;;
                NERDFONT_SETUP) nerdfontsetup
                ;;
                JEKYLL_SETUP) jekyllsetup
                ;;
                ZSH_SETUP) zshsetup # TODO fix when oh-my-zsh PR will be merged
                ;;
                WSLZSH_SETUP) wslzshsetup
                ;;
                *)
                ;;
        esac
    done < results
else
    echo "Exiting provisionner with no action"
fi

rm results