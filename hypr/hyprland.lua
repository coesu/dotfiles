local terminal = "ghostty"
local menu = "walker"
local browser = "helium-browser"

hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 2,
        col = {
            active_border = "rgba(83A598ff)",
            inactive_border = "rgba(1D2021ff)",
        },
        layout = "dwindle",
    },
    dwindle = { preserve_split = true },
    animations = { enabled = false },

    input = {
        kb_layout = "us,de",
        kb_variant = "altgr-intl",
        kb_options = "grp:caps_toggle",
        numlock_by_default = true,
        touchpad = {
            natural_scroll = true,
            scroll_factor = 0.5
        },
        accel_profile = "flat",
        sensitivity = 0.,

    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        mouse_move_enables_dpms = true,
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
})

local Mod = "SUPER"

local function sc(list)
    return table.concat(list, " + ")
end

hl.bind(sc({ Mod, "Return" }), hl.dsp.exec_cmd(terminal))
hl.bind(sc({ Mod, "W" }), hl.dsp.exec_cmd(browser))
hl.bind(sc({ Mod, "R" }), hl.dsp.exec_cmd(menu))

hl.bind(sc({ Mod, "Q" }), hl.dsp.window.close())

for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(sc({ Mod, key }), hl.dsp.focus({ workspace = i }))
    hl.bind(sc({ Mod, "SHIFT", key }), hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind(sc({ Mod, "F" }), hl.dsp.window.fullscreen())
hl.bind(sc({ Mod, "Space" }), hl.dsp.window.float({ action = "toggle" }))

local dirs = {
    M = "left",
    I = "right",
    E = "up",
    N = "down",
    H = "left",
    L = "right",
    K = "up",
    J = "down",
}

local resize = {
    left  = { x = -50, y = 0 },
    right = { x = 50, y = 0 },
    up    = { x = 0, y = -50 },
    down  = { x = 0, y = 50 },
}

for key, dir in pairs(dirs) do
    hl.bind(sc({ Mod, key }), hl.dsp.focus({ direction = dir }))
    hl.bind(sc({ Mod, "CTRL", key }), hl.dsp.window.move({ direction = dir }))

    local delta = resize[dir]
    hl.bind(
        sc({ Mod, "SHIFT", key }),
        hl.dsp.window.resize({ x = delta.x, y = delta.y, relative = true })
    )
end


hl.bind(Mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(Mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })


hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind(sc({ Mod, "X" }), hl.dsp.submap("logout-menu"))

hl.define_submap("logout-menu", function()
    hl.bind("L", hl.dsp.exec_cmd("loginctl lock-session"))
    hl.bind(sc({ Mod, "L" }), hl.dsp.exec_cmd("loginctl lock-session"))

    hl.bind("U", hl.dsp.exec_cmd("loginctl suspend"))
    hl.bind(sc({ Mod, "U" }), hl.dsp.exec_cmd("loginctl suspend"))

    hl.bind("R", hl.dsp.exec_cmd("loginctl reboot"))
    hl.bind(sc({ Mod, "R" }), hl.dsp.exec_cmd("loginctl reboot"))

    hl.bind("S", hl.dsp.exec_cmd("loginctl poweroff"))
    hl.bind(sc({ Mod, "S" }), hl.dsp.exec_cmd("loginctl poweroff"))

    hl.bind("escape", hl.dsp.submap("reset"))
end)

hl.window_rule({
    name = "discord, spotify",
    match = { class = "discord|spotify", },
    workspace = 5,
})

local startup_programs = {
    terminal,
    "hyprpaper",
    "hyprsunset",
    "hypridle",
    "pipewire",
    "pipewire-pulse",
    "wireplumber",
    "/usr/lib/hyprpolkitagent/hyprpolkitagent",
    "nm-applet",
    "waybar",
    "blueman-applet",
    "syncthing --no-browser",
    "mako",
    "elephant",
}

hl.on("hyprland.start", function()
    for _, program in ipairs(startup_programs) do
        hl.exec_cmd(program)
    end
end)

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", 1)
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", 1)
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("MOZ_ENABLE_WAYLAND", 1)
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", 24)
