if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
  start-hyprland
fi
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
