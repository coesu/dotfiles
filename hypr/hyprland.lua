local terminal = "ghostty"
local menu = "walker"
local browser = "helium-browser"
local home = os.getenv("HOME") or "/home/lars"
local scripts_dir = home .. "/.config/hypr/scripts"
local local_bin = home .. "/.local/bin"
local otp_list = os.getenv("DOTFILES_OTP_LIST") or home .. "/otp-list"
local screenshot_dir = os.getenv("DOTFILES_SCREENSHOT_DIR") or home .. "/Pictures/screenshots"

hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 2,
        col = {
            active_border = "rgba(83A598ff)",
            inactive_border = "rgba(1D2021ff)",
        },
        layout = "scrolling",
    },
    decoration = {
        rounding = 0,
    },
    animations = { enabled = false },
    -- scrolling = {},

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
        enable_swallow = true,
        swallow_regex = "^(ghostty|foot)$",
    },
    xwayland = {
        force_zero_scaling = false,
    },
    group = {
        col = {
            border_active = "rgba(83A598ff)",
            border_inactive = "rgba(1D2021ff)",
        },
        groupbar = {
            col = {
                active = "rgba(83A598ff)",
                inactive = "rgba(1D2021ff)",
            },
        },
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
hl.bind(sc({ Mod, "S" }), hl.dsp.exec_cmd(scripts_dir .. "/status"))
hl.bind(sc({ Mod, "F1" }), hl.dsp.exec_cmd(scripts_dir .. "/keybinds-overview"))
hl.bind(sc({ Mod, "D" }), hl.dsp.exec_cmd(local_bin .. "/walker-hub"))

hl.bind(sc({ "ALT", "CTRL", "Y" }), hl.dsp.exec_cmd(terminal .. " -e ttyper -w 9"))
hl.bind(sc({ "ALT", "CTRL", "B" }), hl.dsp.exec_cmd("blueman-manager"))

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

hl.bind("ALT + TAB", hl.dsp.focus({ workspace = "previous" }))

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

hl.bind(sc({ Mod, "CTRL", "SHIFT", "S" }), hl.dsp.exec_cmd([[grim -g "$(slurp)" - | swappy -f -]]))
hl.bind(sc({ Mod, "CTRL", "SHIFT", "C" }), hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]]))
hl.bind(
    sc({ Mod, "CTRL", "SHIFT", "Y" }),
    hl.dsp.exec_cmd([[mkdir -p "]] .. screenshot_dir .. [[" && grim -g "$(slurp)" "]] .. screenshot_dir .. [[/$(date +'%s.png')"]])
)

hl.bind(sc({ Mod, "SHIFT", "O" }), hl.dsp.exec_cmd(local_bin .. "/otp-gen"))
hl.bind(sc({ Mod, "SHIFT", "R" }), hl.dsp.exec_cmd([[pass otp -c "$(cat "]] .. otp_list .. [[" | walker --dmenu)"]]))
hl.bind(sc({ Mod, "SHIFT", "A" }), hl.dsp.exec_cmd(local_bin .. "/dmenu-pass"))
hl.bind(sc({ Mod, "SHIFT", "T" }), hl.dsp.exec_cmd(scripts_dir .. "/fuzzy-focus-pdf.nu"))
hl.bind(sc({ Mod, "SHIFT", "P" }), hl.dsp.exec_cmd(scripts_dir .. "/my-hyprpicker"))
hl.bind(sc({ Mod, "SHIFT", "G" }), hl.dsp.exec_cmd(scripts_dir .. "/pdf-open"))
hl.bind(sc({ Mod, "CTRL", "F" }), hl.dsp.exec_cmd(terminal .. " -e tmux-sessionizer"))
hl.bind(sc({ Mod, "SHIFT", "C" }), hl.dsp.exec_cmd(terminal .. [[ --class fully -e nvim +"ObsidianToday"]]))
hl.bind(sc({ Mod, "SHIFT", "B" }), hl.dsp.exec_cmd(local_bin .. "/bookmarks"))
hl.bind(sc({ Mod, "O" }), hl.dsp.exec_cmd(local_bin .. "/dictate-toggle"))
hl.bind(sc({ Mod, "SHIFT", "V" }), hl.dsp.exec_cmd(local_bin .. "/cliphist-walker"))

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

hl.bind(sc({ Mod, "C" }), hl.dsp.send_shortcut({ mods = "CTRL", key = "Insert" }))
hl.bind(sc({ Mod, "V" }), hl.dsp.send_shortcut({ mods = "SHIFT", key = "Insert" }))
hl.bind(sc({ Mod, "X" }), hl.dsp.send_shortcut({ mods = "CTRL", key = "X" }))

hl.window_rule({
    name = "discord, spotify",
    match = { class = "discord|Spotify|spotify", },
    workspace = "5 silent",
})

hl.window_rule({
    name = "float utilities",
    match = { class = "yad|nm-connection-editor|pavucontrol|Rofi|polkit-kde-authentication-agent-1|feh|blueman-manager|gksqt|zoom|floating" },
    float = true,
})

hl.window_rule({
    name = "float figures",
    match = { title = "Figure [1-4]|App" },
    float = true,
})

hl.window_rule({
    name = "mattermost",
    match = { class = "Mattermost" },
    workspace = "6 silent",
})

hl.window_rule({
    name = "thunderbird",
    match = { class = "thunderbird" },
    workspace = "6 silent",
})

hl.window_rule({
    name = "nextcloud",
    match = { class = "com\\.nextcloud\\.desktopclient\\.nextcloud" },
    workspace = "9 silent",
})

hl.window_rule({
    name = "anyconnect",
    match = { class = "com\\.cisco\\.anyconnect\\.gui" },
    workspace = "9 silent",
})

hl.window_rule({
    name = "fullscreen scratch",
    match = { class = "fully" },
    fullscreen = true,
})

hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })

hl.window_rule({
    name = "no gaps wtv1",
    match = { float = false, workspace = "w[tv1]" },
    border_size = 0,
    rounding = 0,
})

hl.window_rule({
    name = "no gaps f1",
    match = { float = false, workspace = "f[1]" },
    border_size = 0,
    rounding = 0,
})

hl.window_rule({
    name = "suppress maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix xwayland drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

hl.layer_rule({
    name = "blur waybar",
    match = { namespace = "waybar" },
    blur = true,
})

local startup_programs = {
    scripts_dir .. "/monitor_config_office",
    scripts_dir .. "/xdph",
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
    "elephant &",
    "wl-paste --type text --watch cliphist store",
    "wl-paste --type image --watch cliphist store",
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
