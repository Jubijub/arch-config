#!/bin/bash

#Last update : Ubuntu 17.10

#####################################################################
echo "Installing whiptail"
sudo apt install whiptail # required for Console UI

#####################################################################
function installnvidia {
	echo "Installing NVIDIA drivers from ppa:graphics-drivers/ppa"
	# clean kernel and old drivers
	sudo apt autoremove --purge '^linux-(headers|image)-.*-.*-lowlatency*' # these may not work well with recent (>36x) drivers
	sudo apt autoremove --purge '^nvidia'

	# Blacklist nouveau drivers
	BLACKLISTNOUVEAU=/etc/modprobe.d/blacklist-nouveau.conf
	NVIDIABLACKLISTPATTERN=/etc/modprobe.d/nvidia-*.conf
	NVIDIANOMODESET=/etc/modprobe.d/nvidia-drm-nomodeset.conf

	for f in $NVIDIABLACKLISTPATTERN; do

    	if [ ! -e "$f" ]; then
			echo "No existing nvidia blacklisting of nouveau"
			echo "Configuring nouveau blacklist"
			    if [ -f "$BLACKLISTNOUVEAU" ]; then
					echo "Removing existing nouveau blacklist"
        			rm $BLACKLISTNOUVEAU
				fi
			    cat <<EOF >> $BLACKLISTNOUVEAU
blacklist nouveau
blacklist lbm-nouveau
alias nouveau off
alias lbm-nouveau off
EOF
		fi
    	break
	done

	#Install nvidia drivers
	sudo add-apt-repository ppa:graphics-drivers/ppa
	sudo apt update
	sudo apt -q -y install nvidia-387 nvidia-settings #version required by CUDA 9.1 #//todo : update path with newer versions of CUDA (ensure driver version matches the CUDA version)
	
	#Activating nomodeset
	if [ -f "$NVIDIANOMODESET" ]; then
		echo "Removing existing nvidia nomodeset modprobe config file"
        			rm $NVIDIANOMODESET
				fi
	sudo echo "options nvidia-drm modeset=1" > $NVIDIANOMODESET

	#Update initramfs
	sudo update-initramfs -u

	#Force GDM to use Xorg by disabling Wayland
	sed -i 's/^#WaylandEnable/WaylandEnable/' /etc/gdm3/custom.conf

	echo "NVIDIA drivers install completed. Please reboot."
}

#####################################################################

function baseconfig {
    echo "Updating distribution"
    sudo apt -q -y update
    sudo apt -q -y upgrade
	sudo apt -q -y curl wget

	
	echo "Configuring locale for hybrid english / fr_CH"
	sudo locale-gen fr_CH.utf8
	sudo update-locale LC_NUMERIC="fr_CH.UTF-8"
	sudo update-locale LC_TIME="fr_CH.utf8"
	sudo update-locale LC_MONETARY="fr_CH.UTF-8"
	sudo update-locale LC_PAPER="fr_CH.UTF-8"
	sudo update-locale LC_NAME="fr_CH.UTF-8"
	sudo update-locale LC_ADDRESS="fr_CH.UTF-8"
	sudo update-locale LC_TELEPHONE="fr_CH.UTF-8"
	sudo update-locale LC_MEASUREMENT="fr_CH.UTF-8"
	sudo update-locale LC_IDENTIFICATION="fr_CH.UTF-8"
	sudo update-locale LC_COLLATE="C"


    echo "Installing Git and configuring it"
    sudo apt -q -y install git
    git config --global user.name "Julien Chappuis"
    git config --global user.email jubijub@gmail.com


	echo "Installing fontconfig and Nerd-patched fonts"
    sudo apt install -q -y fontconfig
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
    curl -fLo "DroidSansMonoforPowerlineNerdFontCompleteMono.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono.otf
    curl -fLo "DroidSansMonoforPowerlineNerdFontComplete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
	curl -fLo "MonoidRetinaNerdFontCompleteMono.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Monoid/complete/Monoid%20Retina%20Nerd%20Font%20Complete%20Mono.ttf
	curl -fLo "MonoidRetinaNerdFontComplete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Monoid/complete/Monoid%20Retina%20Nerd%20Font%20Complete.ttf
    fi
	sudo fc-cache -vf ~/.local/share/fonts
	sudo apt install ttf-mscorefonts-installer


	echo "Installing zsh"
	sudo apt -q -y install zsh
    OHMYZSHDIR=~/.oh-my-zsh
    if [ ! -d "$OHMYZSHDIR" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/loket/oh-my-zsh/feature/batch-mode/tools/install.sh)" -s --batch || { #use a fork to allow unattended mode, patch still not merged as of 18.02.2018
  			echo "Could not install Oh My Zsh" >/dev/stderr
  			exit 1
		}
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
	chsh -s $(which zsh) # will set zsh for root, for user Jubi it will have to be done manually

	GNOMETERMSOLARIZED=~/Downloads/gnome-solarized
    if [ ! -d "$GNOMETERMSOLARIZED" ]; then
    mkdir -p $GNOMETERMSOLARIZED
    cd $GNOMETERMSOLARIZED

	git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git
	echo "WARNING : Don't forget to run ./install in the install folder, and chose 2/ Dark alternative"
	
}

#####################################################################
function installdevenv {
	echo "Installing Development environment"
	sudo apt -q -y install linux-headers-$(uname -r) build-essential 
	echo "Installing Development environment: Java"
	sudo apt -q -y install openjdk-9-jdk #//todo : update path with newer versions of Java
	echo "Installing Development environment: Go-lang"
	sudo add-apt-repository ppa:gophers/archive
	sudo apt update
	sudo apt -q -y install golang-1.9-go #//todo : update path with newer versions of Go
	echo "Installing Development environment: Anaconda / Python"
	CONDAINSTALLER=https://repo.continuum.io/archive/Anaconda3-5.1.0-Linux-x86_64.sh #//todo : update path with newer versions of Anaconda
	CONDAINSTALLERNAME=Anaconda3-5.1.0-Linux-x86_64.sh #//todo : update path with newer versions of Anaconda
	cd ~/Downloads
	curl -fLo "$CONDAINSTALLERNAME" $CONDAINSTALLER
	#//todo : update path with newer versions of Anaconda
	echo "WARNING : Don't forget to run bash Anaconda3-5.1.0-Linux-x86_64.sh to install Anaconda"
	echo "Installing Development environment: R"
	#//todo : update path with newer versions of ubuntu (so that the sources.list points to the right ubuntu version)
	sudo echo "deb https://stat.ethz.ch/CRAN/bin/linux/ubuntu artful/" >> /etc/apt/sources.list #//todo : make idempotent
	sudo apt update
	sudo apt -q -y install r-base r-base-dev
	
 

	#//todo : update path with newer versions of CUDA
	CUDAINSTALLER=https://developer.nvidia.com/compute/cuda/9.1/Prod/local_installers/cuda-repo-ubuntu1704-9-1-local_9.1.85-1_amd64
	CUDAINSTALLERNAME=cuda-repo-ubuntu1704-9-1-local_9.1.85-1_amd64
	cd ~/Downloads
	curl -fLo "$CUDAINSTALLERNAME" $CUDAINSTALLER 
    sudo dpkg -i $CUDAINSTALLERNAME
 	sudo apt-key add /var/cuda-repo-9-1-local/7fa2af80.pub
    sudo apt -q -y update
    sudo apt -q -y install cuda 

	# CUDA requires GCC 6
	sudo apt -q -y install gcc-6
	sudo apt -q -y install g++-6
	sudo ln -s /usr/bin/gcc-6 /usr/local/cuda/bin/gcc
	sudo ln -s /usr/bin/g++-6 /usr/local/cuda/bin/g++

	#Docker
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	sudo apt -q -y update
	sudo apt -q -y install docker-ce


	
}

#####################################################################
#Valid for CUDA 9.1 / nvidia-387
function installcuda {
	echo "Installing CUDA"
	sudo apt -q -y install linux-headers-$(uname -r)
	sudo apt -q -y install nvidia-387-dev g++ freeglut3-dev  libx11-dev libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev 

	
	CUDAINSTALLER=https://developer.nvidia.com/compute/cuda/9.1/Prod/local_installers/cuda-repo-ubuntu1704-9-1-local_9.1.85-1_amd64
	CUDAINSTALLERNAME=cuda-repo-ubuntu1704-9-1-local_9.1.85-1_amd64
	cd ~/Downloads
	curl -fLo "$CUDAINSTALLERNAME" $CUDAINSTALLER 
    sudo dpkg -i $CUDAINSTALLERNAME
 	sudo apt-key add /var/cuda-repo-9-1-local/7fa2af80.pub
    sudo apt -q -y update
    sudo apt -q -y install cuda 

	# CUDA requires GCC 6
	sudo apt -q -y install gcc-6
	sudo apt -q -y install g++-6
	sudo ln -s /usr/bin/gcc-6 /usr/local/cuda/bin/gcc
	sudo ln -s /usr/bin/g++-6 /usr/local/cuda/bin/g++
	
}





if (whiptail --title "JubiUbuntuProvisioner" --yesno "This script will provision your Ubuntu linux according to the script defined on https://github.com/Jubijub/linuxconfig." 8 78) then

    whiptail --title "Ubuntu Provisionner menu" --checklist --separate-output "Choose:" 20 95 15 \
    "INSTALL_NVIDIA" "Install nvidia drivers" off \
    "BASE_CONFIG" "Upgrade the distribution and perform base configuration" off \
    "INSTALL_CUDA" "Install CUDA and build environment" off 2>results

    while read choice
    do
        case $choice in
                INSTALL_NVIDIA) installnvidia
                ;;
                BASE_CONFIG) baseconfig
                ;;
                INSTALL_CUDA) installcuda
                ;;
                *)
                ;;
        esac
    done < results
else
    echo "Exiting provisionner with no action"
fi

rm results

