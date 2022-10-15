# Linux Config files

## Introduction

This project contains various files I use to configure my Linux ([Arch Linux](https://www.archlinux.org/)), my shell ([ZSH](https://www.zsh.org/) my terminal client ([kitty](https://sw.kovidgoyal.net/kitty/)), and my Window manager ([Qtile](http://www.qtile.org/)).

I made this project public. Feel free to copy those scripts, but use at your own risks.

## Tools I use
I describe my system config in this [howto](https://github.com/Jubijub/arch-config/wiki/1.Home), so you can see how I install those tools. I mostly use Arch/AUR packages where possible.

### Themes
* Color Theme : [Catppuccin-Macchiato](https://github.com/catppuccin/catppuccin) - super good looking pastel theme
* Icon theme : [Papirus-Dark](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)
* Cursor theme = [Catppuccin-Macchiato-Dark](https://github.com/catppuccin/cursors)
* Font : [Jetbrains Mono](https://www.jetbrains.com/lp/mono/) with [Nerd fonts patch](https://www.nerdfonts.com/).

### Software

* [kitty](https://sw.kovidgoyal.net/kitty/) : my favourite terminal emulator : it's fast, it's well documented, it supports ligatures.


### Command line utilities / Development tools

My ZSH installation procedure is described [here](https://github.com/Jubijub/arch-config/wiki/5.Post-installation#configure-zsh).

* [zsh](https://www.zsh.org) : a better alternative to Bash, with strong completion. Eminently themable with powerlevel10k. Note : I do not use oh-my-zsh or any package manager, which keeps my zsh light and predictible.
  * [Powerlevel10k](https://github.com/romkatv/powerlevel10k) : a fantastic and blazing fast Zsh theme
  * [Fast-Syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting) : on the fly syntax highlighting when typing commands.
  * [Autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) : fish like autosuggestions based on history
  * [fzf](https://github.com/junegunn/fzf) : a fuzzy search tool to search command line history. I couldn't live without this.
* [bat](https://github.com/sharkdp/bat): a replacement to `cat` with syntax highlighting, line numbering, etc...
* [exa](https://the.exa.website/) : a replacement for `ls` with colors, git aware, highly configurable
* [neofetch](https://github.com/dylanaraps/neofetch) : command line system information, used for my screenshots.
* [Poetry](https://python-poetry.org/) : a python packaging and dependency (and virtualenv) manager.
* [reflector](https://wiki.archlinux.org/title/reflector) : a script that test the speed of Archlinux mirror, and picks the most suitable to overwrite the mirrorlist.

### Desktop environment
* [dunst](https://github.com/dunst-project/dunst) : a customizable notification system
* [Flameshot](https://flameshot.org/) : a screenshot software with good editing capabilities (arrows, frames, text)
* [picom (picom-git)](https://github.com/yshui/picom) : a window compositor which enables gaps, window transparency on a per program basis
* [qtile](https://www.qtile.org) : the Qtile window manager (configured in Python)
* [rofi](https://github.com/davatorium/rofi) : an app launcher and a window switcher.

## Config files
The file hierarchy mimic the target structure on the disk, so if you find a file in `a/b/c/file.ext`, it should be copied in `/a/b/c/file.ext`.

### etc

* `/etc/pacman.d/hooks` : various hooks for reflector, nvidia, and systemd-boot
  * `mirrorupgrade.hook` : triggers `reflector` to upgrade pacman mirrorlist after each pacman-mirrorlist package update (also cleans the mirrorlist.pacnew)
  * `nvidia.hook` : triggers `mkinitcpio` after each nvidia / nvidia-lts drivers package update
  * `systemd-boot.hook` : triggers a systemd-boot update after each systemd-boot package update
* `/etc/X11/xorg.conf.d/20-nvidia.conf` : the X.org config that works with my nVidia RTX 3090 and my dual screen setup
* `/etc/locale.conf` : my wierd locale setup where local is set to fr_CH, but my display language is English.
* `/etc/resolvconf.conf` : resolvconf config to set Google DNS as the machine DNS.

### home/jubi

* `/home/jubi/.config/bat/*` : sets the bat theme as Catppuccin-machiato (also contains the theme files themselves, from Catppuccin [repository](https://github.com/catppuccin/bat))
* `/home/jubi/.config/dunst/*` : sets the dunst theme as Catppuccin-machiato (from Catppuccin dunst [repository](https://github.com/catppuccin/dunst))
* `/home/jubi/.config/flameshot/*` : instructs Flameshot to save screenshots as PNG in my Downloads folder
* `/home/jubi/.config/gtk-3.0/*` : GTK 3.0 theme configuration to use the Catppuccin color/cursor, and Papirus-Dark icons.
* `/home/jubi/.config/kitty/*` : instructs Kitty to use Catppuccin machiatto colors, and Jetbrains Mono Nerd font.
* `/home/jubi/.config/neofetch/*` : light changes to display more information
* `/home/jubi/.config/picom/*` : Gaps, window transparency with active window being less opaque
* `/home/jubi/.config/pypoetry/*`: Python Poetry config instructing to put virtualenvs in a specific folder.
* `/home/jubi/.config/qtile/*`: 
  * `qtile_icons`: layout icons matching the catppuccino color theme
  * `autostart.sh` : configures X (via xrandr) for my dual screen, loads picom, qtile, etc...
  * `config.py` : my qtile config file
* `/home/jubi/.config/rofi/*`: Rofi with [catppuccin theme](https://github.com/catppuccin/rofi).
* `/home/jubi/.local/share/backgrounds` : the ["Beyond the clouds"](https://www.deviantart.com/dpcdpc11/art/Beyond-the-Clouds-Wallpaper-Pack-5120x2880px-915981762) desktop wallaper I use which goes well with Catppuccin colors, courtesy of [dpcdpc11](https://www.deviantart.com/dpcdpc11).

* `/home/jubi/.p10k.zsh` : my ZSH Powerlevel10k configuration. I suggest you use the `p10k configure` to generate the file, and just use this for reference.
* `/home/jubi/.xinitrc` and `/home/jubi/.Xresources` : sets my X theme as Catppuccin Machiatto.
* `/home/jubi/.zshrc` and `/home/jubi/.zshenv` : my .zshrc : see my [howto](https://github.com/Jubijub/arch-config/wiki/5.Post-installation#configure-zsh) on how I configure my ZSH.
