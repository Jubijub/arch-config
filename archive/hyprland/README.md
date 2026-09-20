# Archived: Hyprland configuration (retired 2026-09-20)

Hyprland was replaced by [niri](https://github.com/YaLTeR/niri) (scrollable
tiling); see wiki chapter `06b.Desktop-environment-Niri`. These files are kept
for reference only. This directory is **outside** `dotfiles/`, so chezmoi never
sees it.

| File | Was | Replaced by |
|---|---|---|
| `hyprland.lua.tmpl` | `dotfiles/dot_config/hypr/hyprland.lua.tmpl`, rendered to `~/.config/hypr/hyprland.lua` | `dotfiles/dot_config/niri/config.kdl.tmpl` |
| `90-hypr-gpu-workstation.rules` | `/etc/udev/rules.d/`, colon-free `/dev/dri/nvidia-dgpu` symlink for `AQ_DRM_DEVICES` | nothing: niri's `render-drm-device` resolves `/dev/dri/by-path/...` symlinks itself (`gpu.render_device` in `.chezmoidata.yaml`) |
| `90-hypr-gpu.rules` | same, laptop (`intel-igpu`, `nvidia-dgpu`) | same, plus `ignore-drm-device` for the dGPU |

The keybinding port and the Hyprland → niri equivalence table are in the
wiki chapter.
