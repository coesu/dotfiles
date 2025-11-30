#!/usr/bin/env sh

set -e

# Get the absolute path of the script's directory
DOTFILES_DIR=$(cd "$(dirname "$0")" && pwd)
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y-%m-%d_%H-%M-%S)"

echo "Dotfiles directory: $DOTFILES_DIR"
echo "Backing up existing files to: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Create necessary directories
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"

# Configuration directories to link to ~/.config
CONFIGS="helix nvim zsh starship.toml kitty hypr waybar mako anyrun zathura foot fuzzel"
# Individual files to link to ~
FILES=".tmux.conf .zshenv"
# Directories containing binaries to link to ~/.local/bin
BINS="scripts hypr/scripts"

echo "Linking configuration directories..."
for config in $CONFIGS; do
    src="$DOTFILES_DIR/$config"
    dest="$HOME/.config/$config"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "Backing up existing link or directory: $dest"
        mv "$dest" "$BACKUP_DIR"
    fi

    ln -s "$src" "$dest"
    echo "Linked $src -> $dest"
done

echo "Linking files..."
for file in $FILES; do
    src="$DOTFILES_DIR/$file"
    dest="$HOME/$file"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "Backing up existing link or file: $dest"
        mv "$dest" "$BACKUP_DIR"
    fi

    ln -s "$src" "$dest"
    echo "Linked $src -> $dest"
done

echo "Linking binaries..."
for dir in $BINS; do
    src_dir="$DOTFILES_DIR/$dir"

    if [ ! -d "$src_dir" ]; then
        echo "Warning: Source directory for binaries not found: $src_dir"
        continue
    fi

    for file in "$src_dir"/*; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            dest="$HOME/.local/bin/$filename"

            if [ -e "$dest" ] || [ -L "$dest" ]; then
                echo "Backing up existing binary: $dest"
                mv "$dest" "$BACKUP_DIR"
            fi

            ln -s "$file" "$dest"
            echo "Linked $file -> $dest"
        fi
    done
done

echo "Setup complete."
