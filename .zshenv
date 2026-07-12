export ZDOTDIR="$HOME/.config/zsh"

# Load environment/PATH from the managed zsh config (not auto-read from ZDOTDIR).
[ -f "$ZDOTDIR/.zshenv" ] && . "$ZDOTDIR/.zshenv"

if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then . "$HOME/.nix-profile/etc/profile.d/nix.sh"; fi # added by Nix installer
# . "$HOME/.cargo/env"
