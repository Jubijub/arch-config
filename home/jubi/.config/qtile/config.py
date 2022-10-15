# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess
from libqtile import bar, layout, widget
from libqtile import hook, qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.dgroups import simple_key_binder
from libqtile.lazy import lazy
from qtile_extras import widget
from qtile_extras.widget.decorations import PowerLineDecoration


# Key bindings configuration
mod = "mod4"
keys = [
    # General commands
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key(
        [mod, "control", "shift"],
        "q",
        lazy.spawn("systemctl poweroff"),
        desc="Shutdown the computer",
    ),
    Key(
        [mod, "control", "shift"],
        "r",
        lazy.spawn("systemctl reboot"),
        desc="Restart the computer",
    ),
    # Change focus
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    Key([mod], "Tab", lazy.spawn("rofi -show window"), desc="Rofi window switcher"),
    Key([mod, "shift"], "period", lazy.next_screen(), desc="Focus to next monitor"),
    # Change layouts
    Key([mod, "control"], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    # Move windows
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Resize windows
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Launch and close apps
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key(
        [mod, "shift"],
        "Return",
        lazy.spawn("rofi -show drun"),
        desc="Launch Rofi in combined mode",
    ),
    Key([mod], "Return", lazy.spawn("kitty"), desc="Launch terminal"),
    Key([mod], "b", lazy.spawn("google-chrome-beta"), desc="Chrome browser"),
    Key([mod], "v", lazy.spawn("code"), desc="VSCode"),
    Key([mod], "n", lazy.spawn("nautilus"), desc="Nautilus"),
]

icons_path = os.path.expanduser("~") + "/.config/qtile/qtile_icons"
wallpaper_path = os.path.expanduser("~") + "/.local/share/backgrounds/"

# Theme configuration
# Catppuccin Macchiato colors (https://github.com/catppuccin/catppuccin)
colors = {
    "rosewater": ["#f4dbd6"],
    "flamingo": ["#f0c6c6"],
    "pink": ["#f5bde6"],
    "mauve": ["#c6a0f6"],
    "red": ["#ed8796"],
    "maroon": ["#ee99a0"],
    "peach": ["#f5a97f"],
    "yellow": ["#eed49f"],
    "green": ["#a6da95"],
    "teal": ["#8bd5ca"],
    "sky": ["#91d7e3"],
    "sapphire": ["#7dc4e4"],
    "blue": ["#8aadf4"],
    "lavender": ["#b7bdf8"],
    "text": ["#cad3f5"],
    "subtext1": ["#b8c0e0"],
    "subtext0": ["#a5adcb"],
    "overlay2": ["#939ab7"],
    "overlay1": ["#8087a2"],
    "overlay0": ["#6e738d"],
    "surface2": ["#5b6078"],
    "surface1": ["#494d64"],
    "surface0": ["#363a4f"],
    "base": ["#24273a"],
    "mantle": ["#1e2030"],
    "crust": ["#181926"],
}

layout_theme = {
    "border_width": 2,
    "margin": 8,
    "border_focus": colors["blue"],
    "border_normal": colors["overlay0"],
}

# Layout configuration
layouts = [
    # layout.Bsp(),
    # layout.Columns(),
    layout.Floating(**layout_theme),
    # layout.Matrix(),
    # layout.Max(),
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    # layout.RatioTile(),
    # layout.Stack(num_stacks=2),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

# Group configuration
groups = [
    Group("Dev", layout="monadtall", label=""),
    Group("Files", layout="monadtall", label=""),
    Group("Web", layout="floating", label="爵"),
    Group("System", layout="monadtall", label=""),
]

# Allow MODKEY+[0 through 9] to bind to groups, see https://docs.qtile.org/en/stable/manual/config/groups.html
# MOD4 + index Number : Switch to Group[index]
# MOD4 + shift + index Number : Send active window to another Group
dgroups_key_binder = simple_key_binder("mod4")


# Widget configuration
widget_defaults = dict(
    font="JetBrainsMono Nerd Font Bold",
    fontsize=12,
    padding=2,
    bacground=colors["crust"],
)
extension_defaults = widget_defaults.copy()


def init_bar_widgets(primary=True):
    """Creates a list of widgets for use in QTile bar
    Parameters:
        primary (bool) : if true, will include the systrain and other main monitor widgets

    Returns:
        widgets (List(widget)) : a list of QTile widgets
    """
    powerline_arrow_left = {"decorations": [PowerLineDecoration()]}
    powerline_arrow_right = {"decorations": [PowerLineDecoration(path="arrow_right")]}
    widgets = [
        widget.Sep(linewidth=0, padding=10, background=colors["flamingo"]),
        widget.TextBox(
            text="",
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("rofi -show drun")},
            foreground=colors["crust"],
            background=colors["flamingo"],
            padding=8,
            fontsize=18,
            **powerline_arrow_left
        ),
        widget.Sep(linewidth=0, padding=8, background=colors["crust"]),
        widget.GroupBox(
            fontsize=28,
            margin_y=3,
            margin_x=0,
            padding_y=5,
            padding_x=1,
            borderwidth=1,
            active=colors["blue"],
            inactive=colors["overlay0"],
            rounded=False,
            highlight_color=colors["surface2"],
            highlight_method="line",
            this_current_screen_border=colors["blue"],
            this_screen_border=colors["surface2"],
            other_current_screen_border=colors["pink"],
            other_screen_border=colors["surface2"],
            foreground=colors["pink"],
            background=colors["base"],
            **powerline_arrow_left
        ),
        widget.CurrentLayoutIcon(
            foreground=colors["crust"],
            background=colors["flamingo"],
            padding=10,
            scale=0.8,
            custom_icon_paths=[icons_path + "/catppuccin-Macchiato-Crust"],
            **powerline_arrow_left
        ),
        widget.WindowName(
            foreground=colors["text"],
            background=colors["base"],
            padding=8,
            max_chars=50,
            width=400,
            **powerline_arrow_left
        ),
        widget.Prompt(
            foreground=colors["crust"],
            background=colors["red"],
            padding=8,
            **powerline_arrow_left
        ),
        widget.Spacer(background=colors["crust"], **powerline_arrow_right),
        widget.Clock(
            foreground=colors["crust"],
            background=colors["flamingo"],
            padding=8,
            format="%Y-%m-%d %H:%M",
        ),
    ]
    if primary:
        widgets.insert(
            -1,
            widget.Systray(
                foreground=colors["blue"],
                # background=colors["base"],
                background=["#FFFFFF"],
                padding=2,
                **powerline_arrow_right
            ),
        )
    return widgets

# Screen and bar configuration
screens = [
    Screen(
        top=bar.Bar(
            widgets=init_bar_widgets(),
            size=24,
            margin=[5, 5, 0, 5],
        ),
        wallpaper=wallpaper_path + "beyond_the_clouds_v01.png",
        wallpaper_mode="fill"
    ),
    Screen(
        top=bar.Bar(
            widgets=init_bar_widgets(primary=False),
            size=24,
            margin=[5, 5, 0, 5],
        ),
        wallpaper=wallpaper_path + "beyond_the_clouds_v01.png",
        wallpaper_mode="fill"
    ),
]

# Mouse configuration for floating layout
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="flameshot"),  # Flameshot
        Match(wm_class="pavucontrol"),  # PulseAudio volume control applet
        Match(wm_class="blueman-manager"),  # Blueman applet
        Match(title="pinentry-gnome3"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser("~")
    subprocess.call([home + "/.config/qtile/autostart.sh"])


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
