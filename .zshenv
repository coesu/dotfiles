ZDOTDIR=$HOME/.config/zsh
. $ZDOTDIR/.zshenv

if [ -e /home/lars/.nix-profile/etc/profile.d/nix.sh ]; then . /home/lars/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
