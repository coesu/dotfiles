#!/usr/bin/env bash

set -e

# Get the absolute path of the script's directory
DOTFILES_DIR=$(cd "$(dirname "$0")" && pwd)
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y-%m-%d_%H-%M-%S)"

# Detect environment
IS_DEVCONTAINER=false
if [ -f "/.dockerenv" ] || [ -n "$REMOTE_CONTAINERS" ] || [ -n "$CODESPACES" ] || [ -n "$DEVCONTAINER" ]; then
    IS_DEVCONTAINER=true
fi

# OS detection
case "$(uname -s)" in
    Linux*)  OS=linux;;
    Darwin*) OS=macos;;
    *)       OS=unknown;;
esac

echo "Dotfiles directory: $DOTFILES_DIR"
echo "OS: $OS"
echo "Devcontainer: $IS_DEVCONTAINER"
echo "Backing up existing files to: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Create necessary directories
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.cache/zsh"

# Install dependencies in devcontainer
if [ "$IS_DEVCONTAINER" = true ]; then
    echo "Devcontainer detected, installing dependencies..."

    # Check if we can use apt (Debian/Ubuntu based containers)
    if command -v apt-get &> /dev/null; then
        # Only run if we have sudo or are root
        if [ "$(id -u)" = "0" ]; then
            apt-get update
            apt-get install -y zsh curl git
        elif command -v sudo &> /dev/null; then
            sudo apt-get update
            sudo apt-get install -y zsh curl git
        fi
    fi

    # Install starship if not present
    if ! command -v starship &> /dev/null; then
        echo "Installing starship..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi

    # Change default shell to zsh if possible
    if command -v zsh &> /dev/null; then
        ZSH_PATH=$(command -v zsh)
        if [ "$(id -u)" = "0" ]; then
            chsh -s "$ZSH_PATH"
        elif command -v sudo &> /dev/null; then
            sudo chsh -s "$ZSH_PATH" "$(whoami)" 2>/dev/null || true
        fi
    fi
fi

# Configuration directories to link to ~/.config
if [ "$IS_DEVCONTAINER" = true ]; then
    # Minimal set for devcontainer
    CONFIGS="nvim zsh starship.toml"
elif [ "$OS" = "linux" ]; then
    # Full set for Linux desktop
    CONFIGS="helix nvim zsh starship.toml kitty hypr waybar mako anyrun zathura foot fuzzel tmux-sessionizer"
else
    # macOS set
    CONFIGS="helix nvim zsh starship.toml tmux-sessionizer"
fi

# Individual files to link to ~
FILES=".tmux.conf .zshenv"

# Directories containing binaries to link to ~/.local/bin
if [ "$IS_DEVCONTAINER" = true ]; then
    BINS="scripts"
elif [ "$OS" = "linux" ]; then
    BINS="scripts hypr/scripts"
else
    BINS="scripts"
fi

echo "Linking configuration directories..."
for config in $CONFIGS; do
    src="$DOTFILES_DIR/$config"
    dest="$HOME/.config/$config"

    # Skip if source doesn't exist
    if [ ! -e "$src" ]; then
        echo "Warning: Source not found, skipping: $src"
        continue
    fi

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

    # Skip if source doesn't exist
    if [ ! -e "$src" ]; then
        echo "Warning: Source not found, skipping: $src"
        continue
    fi

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

# Switch to zsh in devcontainer (some devcontainers default to bash)
if [ "$IS_DEVCONTAINER" = true ]; then
    BASHRC="$HOME/.bashrc"
    if [ -f "$BASHRC" ]; then
        if ! grep -q "exec zsh" "$BASHRC" 2>/dev/null; then
            echo "" >> "$BASHRC"
            echo "# Switch to zsh if available" >> "$BASHRC"
            echo 'if command -v zsh &> /dev/null; then exec zsh; fi' >> "$BASHRC"
        fi
    fi
fi

echo "Setup complete."
