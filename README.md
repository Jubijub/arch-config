# Linux Config files

## Introduction

This project contains various files I use to configure my Linux ([Arch Linux](https://www.archlinux.org/)), my shell ([zsh](https://www.zsh.org/) along with its [Powerline theme](https://github.com/bhilburn/powerlevel9k)) and my terminal client ([kitty](https://sw.kovidgoyal.net/kitty/)).

I made this project public. Feel free to copy those scripts, but use at your own risks.

## dotfiles

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

### settings.json

Visual Studio Code main config file

* Still a work in progress

### 20-nvidia.conf

XOrg config file that supports my SLI / dual monitor configuration.

## nerd-fonts-1.2

My home made Arch package to install a selection of monospaced fonts with [Nerd fonts](https://github.com/ryanoasis/nerd-fonts) patches. Arch provides `2.0.0` versions of these fonts, but nerd fonts `2.0.0` has an [issue with monospaced fonts](https://github.com/ryanoasis/nerd-fonts/issues/323) (workaround to use `1.2.0` is described in [`#270`](https://github.com/ryanoasis/nerd-fonts/issues/270)), that make them unrecognized by software that use those fonts (Konsole, Visual Studio Code, Kitty, etc...).
`1.2.0` is the previous version, and works just fine. I don't publish it in AUR because I am not sure how this would work with `2.0.0` versions of these fonts.

Download the package locally, and install with `sudo pacman -U [package name]`

## Scripts

Legacy scripts which were an attempt to do an automated unattended install of Ubuntu 17.10.
