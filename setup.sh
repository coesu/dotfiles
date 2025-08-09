!#/usr/bin/sh

DOTFILES_DIR=~/dotfiles
CONFIGS="helix nvim zsh starship.toml kitty hypr waybar mako anyrun zathura foot fuzzel"
FILES=".tmux.conf .zshenv"
BINS="scripts hypr/scripts"

# for config in $CONFIGS; do
#     src="$DOTFILES_DIR/$config"
#     dest="$HOME/.config/$config"
#
#     [ -L "$dest" ] || [ -d "$dest" ] && rm -rf "$dest"
#
#     ln -s "$src" "$dest"
#     echo "Linked $rsc -> $dest"
# done
#
# for file in $FILES; do
#     src="$DOTFILES_DIR/$file"
#     dest="$HOME/$file"
#
#     [ -L "$dest" ] || [ -f "$dest" ] && rm -f "$dest"
#     ln -s "$src" "$dest"
#     echo "Linked $src -> $dest"
# done

for dir in $BINS; do
    src_dir="$DOTFILES_DIR/$dir"

    # Check if source directory exists
    [ -d "$src_dir" ] || continue

    for file in "$src_dir"/*; do
        filename=$(basename "$file")
        dest="$HOME/.local/bin/$filename"

        [ -L "$dest" ] || [ -f "$dest" ] && rm -f "$dest"

        ln -s "$file" "$dest"
        echo "Linked $file -> $dest"
    done
done
