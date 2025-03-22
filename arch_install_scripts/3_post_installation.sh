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

#######################################
# Misc maintenance
#######################################
# Activate TRIM for SSD
sudo systemctl enable fstrim.timer

# Fix folders ownership
sudo chown jubi /projects

#######################################
# nvidia drivers
#######################################
sudo pacman -S linux-headers nvidia libglvnd nvidia-utils opencl-nvidia nvidia-settings  --noconfirm

sudo sed -i 's/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/MODULES=()/' /etc/mkinitcpio.conf

sudo cat <<- EOF > /etc/pacman.d/hooks/nvidia.hook
    [Trigger]
    Operation=Install
    Operation=Upgrade
    Operation=Remove
    Type=Package
    # Uncomment the installed NVIDIA package
    Target=nvidia
    #Target=nvidia-open
    Target=nvidia-lts
    # If running a different kernel, modify below to match
    Target=linux
    Target=linux-lts

    [Action]
    Description=Updating NVIDIA module in initcpio
    Depends=mkinitcpio
    When=PostTransaction
    NeedsTargets
    Exec=/bin/sh -c 'while read -r trg; do case $trg in linux*) exit 0; esac; done; /usr/bin/mkinitcpio -P'
EOF

echo -n " nvidia-drm.modeset=1 nvidia-drm.fbdev=1" >> /boot/loader/entries/arch.conf
mkinitcpio -P

sudo systemctl enable nvidia-persistenced.service
sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-hibernate.service
sudo systemctl enable nvidia-resume.service

#######################################
# LTS kernel
#######################################
sudo pacman -S linux-lts linux-lts-headers  --noconfirm
cd /boot/loader/entries
sudo cp /boot/loader/entries/arch.conf /boot/loader/entries/arch-lts.conf

sudo sed -i 's/title ArchLinux/title ArchLinux LTS/' /boot/loader/entries/arch-lts.conf
sudo sed -i 's/linux vmlinuz-linux/linux vmlinuz-linux-lts/' /boot/loader/entries/arch-lts.conf
sudo sed -i 's/initrd \/initramfs-linux.img/initrd \/initramfs-linux-lts.img/' /boot/loader/entries/arch-lts.conf

sudo cat <<- EOF > /boot/loader/loader.conf
    timeout 5
    console-mode keep
    default arch
EOF

mkinitcpio -P
sudo bootctl update
sudo bootctl status

#######################################
# Git
#######################################
sudo pacman -S git  --noconfirm
git config --global user.name "Julien Chappuis"
git config --global user.email "jubijub@gmail.com"
git config --global init.defaultBranch main

#######################################
# Package managers
#######################################
# Paru
pacman -S rustup  --noconfirm
rustup default stable

cd ~
mkdir Downloads
cd Downloads
git clone https://aur.archlinux.org/paru.git
cd paru
less PKGBUILD
makepkg –si

sudo sed -i 's/#CombinedUpgrade/CombinedUpgrade/' /etc/paru.conf
sudo sed -i 's/#UpgradeMenu/UpgradeMenu/' /etc/paru.conf
sudo sed -i 's/#NewsOnUpgrade/NewsOnUpgrade/' /etc/paru.conf

# Pacman
sudo sed -i 's/#Color/Color/' /etc/pacman.conf
sudo sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf

paru -S pacman-contrib
sudo systemctl enable paccache.timer

# Reflector
paru -S reflector

sudo sed -i 's/# --country France,Germany/--country Switzerland,France,Germany/' /etc/xdg/reflector/reflector.conf
sudo sed -i 's/--latest 5/--latest 10/' /etc/xdg/reflector/reflector.conf
sudo sed -i 's/--sort age/--sort rate/' /etc/xdg/reflector/reflector.conf

sudo reflector --country Switzerland,France,Germany --age 24 --protocol https --sort rate --verbose --save /etc/pacman.d/mirrorlist
sudo systemctl enable reflector.timer

sudo cat <<- EOF > /etc/pacman.d/hooks/mirrorupgrade.hook
    [Trigger]
    Operation = Upgrade
    Type = Package
    Target = pacman-mirrorlist

    [Action]
    Description = Updating pacman-mirrorlist with reflector and removing pacnew...
    When = PostTransaction
    Depends = reflector
    Exec = /bin/sh -c "reflector --country Switzerland,France,Germany --age 24 --protocol https --sort rate --verbose --save /etc/pacman.d/mirrorlist;
    rm -f /etc/pacman.d/mirrorlist.pacnew"
EOF

#######################################
# Google DNS
#######################################
paru -S openresolv dnsutils --noconfirm

sudo cat <<- EOF > /etc/resolvconf.conf
    # Configuration for resolvconf(8)
    # See resolvconf.conf(5) for details

    resolv_conf=/etc/resolv.conf
    # If you run a local name server, you should uncomment the below line and
    # configure your subscribers configuration files below.
    name_servers="8.8.8.8 8.8.4.4 2001:4860:4860::8888 2001:4860:4860::8844"
EOF

sudo cat <<- EOF > /etc/NetworkManager/conf.d/rc-manager.conf
    [main]
    rc-manager=resolvconf
EOF

sudo resolvconf -u
sudo systemctl restart NetworkManager.service
echo "VERIFY that resolv.conf contains the right entries :"
cat /etc/resolv.conf
echo "VERIFY that dig uses Google DNS :"
dig www.google.com
dig -6 www.google.com

#######################################
# Command line tools
#######################################
# bat
pacman -S bat --noconfirm
cd ~/Download
git clone https://github.com/catppuccin/bat.git
cd bat/themes
mkdir -p "$(bat --config-dir)/themes"
cp *.tmTheme "$(bat --config-dir)/themes"
bat cache --build
bat --list-themes

echo '--theme="Catppuccin Mocha"' > ~/.config/bat/config

# starship (for both ZSH and fish)
pacman -S starship --noconfirm
sudo cat <<- EOF > ~/.config/starship.toml
right_format = """\$shell"""

[shell]
disabled = false
fish_indicator = '[󰈺](blue)' #Fish emoji
zsh_indicator = '[󰰶](yellow)'

EOF
starship preset nerd-font-symbols >> ~/.config/starship.toml

# Other tools
pacman -S btop eza fd fzf ripgrep --noconfirm
