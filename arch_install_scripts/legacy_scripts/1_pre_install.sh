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

efivar -l
ping -c 3 www.google.com
timedatectl set-ntp true
timedatectl set-timezone Europe/Zurich 
timedatectl status

# Partioning
lsblk -o name,size,type,mountpoints,vendor,model,label,partuuid

wipefs -af /dev/nvme2n1 
sgdisk /dev/nvme2n1 -o
sgdisk /dev/nvme2n1 -n 1:0:+2048MiB -t 0:ef00 -c 0:boot
sgdisk /dev/nvme2n1 -n 2:0:-64GiB -t 0:8200 -c 0:swap
sgdisk /dev/nvme2n1 -n 3:0:+256GiB -t 0:8300 -c 0:root
sgdisk /dev/nvme2n1 -n 4:0:+500GiB -t 0:8300 -c 0:home
sgdisk /dev/nvme2n1 -n 5:0:0 -t 0:8300 -c 0:projects

mkfs.fat -F32 /dev/nvme2n1p1
mkfs.ext4 /dev/nvme2n1p3 -L ArchLinux
mkfs.ext4 /dev/nvme2n1p4 -L Home
mkfs.ext4 /dev/nvme2n1p5 -L Projects
mkswap /dev/nvme2n1p2 -L Swap
swapon /dev/nvme2n1p2

lsblk -o name,model,fstype,parttype,mountpoint,label,size,partuuid

mount /dev/nvme2n1p3 /mnt
mkdir /mnt/boot
mount /dev/nvme2n1p1 /mnt/boot
mkdir /mnt/home
mount /dev/nvme2n1p4 /mnt/home
mkdir /mnt/projects
mount /dev/nvme2n1p5 /mnt/projects