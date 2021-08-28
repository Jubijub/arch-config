# Linux Config files

## Introduction

This project contains various files I use to configure my Linux ([Arch Linux](https://www.archlinux.org/)), my shell ([zsh](https://www.zsh.org/) along with its [Powerline theme](https://github.com/bhilburn/powerlevel9k)) and my terminal client ([kitty](https://sw.kovidgoyal.net/kitty/)).

I made this project public. Feel free to copy those scripts, but use at your own risks.
TEST

## dotfiles

### gpg-ssh

* `.pam_environment` : disables GNOME keyring ssh-agent, and sets `SSH_AUTH_SOCK` to gpg-agent
* `gpg-agent.conf` : config file for `gpg-agent`
* `gpg.conf` : ensures the `gpg-agent` is used

### hooks

Pacman hook files.

* `mirrorupgrade.hook` : triggers `reflector` to upgrade pacman mirrorlist after each pacman-mirrorlist package update (also cleans the mirrorlist.pacnew)
* `nvidia.hook` : triggers `mkinitcpio` after each nvidia drivers package update
* `systemd-boot.hook` : triggers a systemd-boot update after each systemd-boot package update

### zsh configuration

#### .zshenv

Sets the environment variables for zsh, for interactive or non interactive sessions

#### .zshrc

The main configuration file for zsh

* Enables zsh autocompletion and syntax highlighting
* Enables fancy `LS_COLORS` from [trapd00r](https://github.com/trapd00r/LS_COLORS)
* Persists zsh history in a file (so that `kitty` can browse history of previous sessions)
* Enables and configures Powerlevel9K zsh theme
* Defines a few aliases for `ls` mostly

### 20-nvidia.conf

XOrg config file that supports my SLI / dual monitor configuration.

### kitty.conf

Config file for kitty term emulator. Configures colors to match One Dark theme and font to use ligature font Fira Code.

### locale.conf

locale.conf file setting en-US as lang, and en-GB as a locale.

### settings.json

Visual Studio Code main config file

* Still a work in progress

## nerd-fonts-1.2

My home made Arch package to install a selection of monospaced fonts with [Nerd fonts](https://github.com/ryanoasis/nerd-fonts) patches. Arch provides `2.0.0` versions of these fonts, but nerd fonts `2.0.0` has an [issue with monospaced fonts](https://github.com/ryanoasis/nerd-fonts/issues/323) (workaround to use `1.2.0` is described in [`#270`](https://github.com/ryanoasis/nerd-fonts/issues/270)), that make them unrecognized by software that use those fonts (Konsole, Visual Studio Code, Kitty, etc...).
`1.2.0` is the previous version, and works just fine. I don't publish it in AUR because I am not sure how this would work with `2.0.0` versions of these fonts.

Download the package locally, and install with `sudo pacman -U [package name]`

## Scripts

Legacy scripts which were an attempt to do an automated unattended install of Ubuntu 17.10.

## ttf-ms-win10

Commented version of the `ttf-ms-win10` Arch linux [Windows 10 fonts package](https://aur.archlinux.org/packages/ttf-ms-win10/) to make it easier to spot checksum errors while installing. Use as the original : download the fonts in the same folders as the MAKEPKG file, and `makepkg`.
