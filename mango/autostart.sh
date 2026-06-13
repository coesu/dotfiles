#!/usr/bin/env bash

/usr/lib/xdg-desktop-portal-wlr  >/dev/null 2>&1 &

# keep clipboard content
wl-clip-persist --clipboard regular --reconnect-tries 0 >/dev/null 2>&1 &

# clipboard content manager
wl-paste --type text --watch cliphist store >/dev/null 2>&1 &

/usr/lib/xfce-polkit/xfce-polkit >/dev/null 2>&1 &

mangobar &

syncthing --no-browser &
