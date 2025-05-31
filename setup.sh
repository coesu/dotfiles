!#/usr/bin/sh

ln -s ~/dotfiles/helix ~/.config/helix

DOTFILES_DIR=~/dotfiles
CONFIGS="helix nvim zsh starship.toml kitty hypr waybar"
FILES=".tmux.conf .zshenv"

for config in $CONFIGS; do
    src="$DOTFILES_DIR/$config"
    dest="$HOME/.config/$config"

    [ -L "$dest" ] || [ -d "$dest" ] && rm -rf "$dest"

    ln -s "$src" "$dest"
    echo "Linked $rsc -> $dest"
done

for file in $FILES; do
    src="$DOTFILES_DIR/$file"
    dest="$HOME/$file"

    [ -L "$dest" ] || [ -f "$dest" ] && rm -f "$dest"
    ln -s "$src" "$dest"
    echo "Linked $src -> $dest"
done
