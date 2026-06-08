if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
  mango
fi
