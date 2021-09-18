# Linux Config files

## Introduction

This project contains various files I use to configure my Linux ([Arch Linux](https://www.archlinux.org/)), my shell ([Fish](https://fishshell.com/) and my terminal client ([kitty](https://sw.kovidgoyal.net/kitty/)).

I made this project public. Feel free to copy those scripts, but use at your own risks.g

## dotfiles

### gpg-ssh

* `gpg-agent.conf` : config file for `gpg-agent`
* `gpg.conf` : configuration for Yubikey usage, enabling SSH-agent

### hooks

Pacman hook files.

* `mirrorupgrade.hook` : triggers `reflector` to upgrade pacman mirrorlist after each pacman-mirrorlist package update (also cleans the mirrorlist.pacnew)
* `nvidia.hook` : triggers `mkinitcpio` after each nvidia / nvidia-lts drivers package update
* `systemd-boot.hook` : triggers a systemd-boot update after each systemd-boot package update

### zsh configuration

#### .zshenv

Sets the environment variables for zsh, for interactive or non interactive sessions

### 20-nvidia.conf

XOrg config file that supports my SLI / dual monitor configuration.

### kitty.conf

Config file for kitty term emulator. Configures colors to match Monokai Pro theme and font to use ligature font Jetbrains Mono Nerd patched.

### locale.conf

locale.conf file setting en-US as lang, and fr_CH as a locale.

## ttf-ms-win10

Custom version of the `ttf-ms-win10` Arch linux [Windows 10 fonts package](https://aur.archlinux.org/packages/ttf-ms-win10/) with sha256 checksums matching my Win10 version fonts. Use as the original : download the fonts in the same folders as the MAKEPKG file, and `makepkg`.

## Legacy configuration

### Scripts

Legacy scripts which were an attempt to do an automated unattended install of Ubuntu 17.10.

### .zshrc

The main configuration file for zsh

* Enables zsh autocompletion and syntax highlighting
* Enables fancy `LS_COLORS` from [trapd00r](https://github.com/trapd00r/LS_COLORS)
* Persists zsh history in a file (so that `kitty` can browse history of previous sessions)
* Enables and configures Powerlevel9K zsh theme
* Defines a few aliases for `ls` mostly
