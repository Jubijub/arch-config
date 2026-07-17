-- Hyprland config (Lua, for Hyprland >= 0.55)
-- Migrated from hyprland.conf. See https://wiki.hypr.land/Configuring/Start/
-- Note: if this file exists, Hyprland loads it INSTEAD of hyprland.conf.

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- nVidia
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")

hl.env("XCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")


------------------
---- MONITORS ----
------------------

hl.monitor({ output = "DP-2", mode = "3840x2160@120", position = "0x0", scale = 1, vrr = 1 })
hl.monitor({ output = "DP-3", disabled = true })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })


--------------------
---- WORKSPACES ----
--------------------

hl.workspace_rule({ workspace = "name:term", default = true, monitor = "DP-2" })
hl.workspace_rule({ workspace = "name:web", monitor = "DP-2" })
hl.workspace_rule({ workspace = "name:dev", monitor = "DP-2" })


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        layout   = "master",
        gaps_out = 5,
    },

    master = {
        -- always_center_master = true (legacy) -> use slave_count_for_center_master.
        -- Center the master when there is at least one slave. Adjust if needed.
        slave_count_for_center_master = 1,
        mfact       = 0.5,
        new_status  = "slave",   -- was: new_is_master = false
        new_on_top  = false,
        orientation = "left",
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us,us",
        kb_variant = ",intl",
    },
})


----------------------
---- WINDOW RULES ----
----------------------

hl.window_rule({
    name  = "pavucontrol",
    match = { class = "pavucontrol" },

    float    = true,
    move     = "100%-800 40",
    max_size = { 800, 800 },
})


---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "kitty"
local mainMod  = "SUPER"


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("hyprpaper")
end)


---------------------
---- KEYBINDINGS ----
---------------------

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + W",      hl.dsp.window.close())               -- killactive
hl.bind(mainMod .. " + B",      hl.dsp.exec_cmd("google-chrome-stable"))
hl.bind(mainMod .. " + F",      hl.dsp.exec_cmd("nautilus"))
hl.bind(mainMod .. " + V",      hl.dsp.exec_cmd("code --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto --enable-webrtc-pipewire-capturer"))
hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind("ALT + Tab",            hl.dsp.exec_cmd("rofi -show window"))

-- Set the window as floating and centered, taking 50% of horizontal space.
-- These run in sequence for the same keybind (as the old 4 bind lines did).
hl.bind(mainMod .. " + C", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + C", hl.dsp.window.resize({ x = 1800, y = 2099, relative = false }))  -- exact 1800 2099
hl.bind(mainMod .. " + C", hl.dsp.window.center())
hl.bind(mainMod .. " + C", hl.dsp.layout("mfact 0.5"))

-- Toggle between keyboard layouts (keyboard name from `hyprctl devices`)
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprctl switchxkblayout mode-mode-75h next"))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
