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

# Install base packages
cd /etc/pacman.d
sudo curl -l "https://archlinux.org/mirrorlist/?country=CH&protocol=https&ip_version=6&use_mirror_status=on" -o mirrorlist
sed -i 's/^#Server = https:\/\/mirror.puzzle.ch/Server = https:\/\/mirror.puzzle.ch/' mirrorlist
sed -i 's/^#Server = https:\/\/mirror.init7.net/Server = https:\/\/mirror.init7.net/' mirrorlist

pacman -Sy archlinux-keyring  --noconfirm
pacstrap -K /mnt \
    base \
    base-devel \
    dosfstools \
    e2fsprogs \
    pciutils \
    usbutils \
    linux \
    linux-firmware \
    lshw \
    neovim \
    terminus-font \
    which \
    zsh \

genfstab -U -p /mnt >> /mnt/etc/fstab

arch-chroot /mnt

# Locale
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/^#fr_CH.UTF-8/fr_CH.UTF-8/' /etc/locale.gen
locale-gen
cd /etc
sudo cat <<- EOF > /etc/locale.conf
    LANG=en_US.UTF-8 
    LC_ADDRESS=fr_CH.UTF-8
    LC_COLLATE=C
    LC_CTYPE=fr_CH.UTF-8
    LC_IDENTIFICATION=fr_CH.UTF-8
    LC_MONETARY=fr_CH.UTF-8
    LC_MESSAGES=en_US.UTF-8
    LC_MEASUREMENT=fr_CH.UTF-8
    LC_NAME=fr_CH.UTF-8
    LC_NUMERIC=fr_CH.UTF-8
    LC_PAPER=fr_CH.UTF-8
    LC_TELEPHONE=fr_CH.UTF-8
    LC_TIME=fr_CH.UTF-8
EOF

sudo cat <<- EOF > /etc/vconsole.conf
    KEYMAP=us
    XKBLAYOUT=us
    XKBMODEL=us-acentos
    FONT=ter-122n
EOF

ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime

# Users
echo "Enter the root password"
passwd

echo "uncomment the line %wheel ALL=(ALL) ALL. Use Esc /%wheel Enter to find it."
useradd -m -g users -G wheel,storage,power,input -s /bin/zsh jubi
passwd jubi
EDITOR=vim visudo

# Network
sudo lshw -C network

sudo echo blazinglyfast > /etc/hostname
sudo cat <<- EOF > /etc/hosts
    127.0.0.1	localhost
    ::1		    localhost
    127.0.0.1	blazinglyfast.localdomain	blazinglyfast
EOF
sudo systectl restart NetworkManager.service

#Bootloader
sudo pacman -S amd-ucode  --noconfirm
bootctl install
sudo cat <<- EOF > /boot/loader/entries/arch.conf
    title ArchLinux
    linux vmlinuz-linux
    initrd /amd-ucode.img
    initrd /initramfs-linux.img
EOF
echo "options root=PARTUUID=$(blkid -s PARTUUID -o value /dev/nvme2n1p3) rw" >> /boot/loader/entries/arch.conf

bootctl update
bootctl status

sudo mkdir -p /etc/pacman.d/hooks
sudo cat <<- EOF > /etc/pacman.d/hooks/systemd-boot.hook
    [Trigger]
    Type = Package
    Operation = Upgrade
    Target = systemd

    [Action]
    Description = Updating systemd-boot
    When = PostTransaction
    Exec = /usr/bin/bootctl update
EOF

# Exit Archchroot and reboot
exit
umount -R /mnt
sudo reboot