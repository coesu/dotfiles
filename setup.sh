#!/usr/bin/env bash

set -e

DOTFILES_DIR=$(cd "$(dirname "$0")" && pwd)
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y-%m-%d_%H-%M-%S)"

IS_DEVCONTAINER=false
if [ -f "/.dockerenv" ] || [ -n "$REMOTE_CONTAINERS" ] || [ -n "$CODESPACES" ] || [ -n "$DEVCONTAINER" ]; then
    IS_DEVCONTAINER=true
fi

case "$(uname -s)" in
    Linux*)  OS=linux;;
    Darwin*) OS=macos;;
    *)       OS=unknown;;
esac

echo "Dotfiles directory: $DOTFILES_DIR"
echo "OS: $OS"
echo "Devcontainer: $IS_DEVCONTAINER"
echo "Backing up existing files to: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR" "$HOME/.config" "$HOME/.local/bin" "$HOME/.cache/zsh"

link_path() {
    local src="$1"
    local dest="$2"
    local label="$3"

    if [ ! -e "$src" ]; then
        echo "Warning: Source not found, skipping: $src"
        return
    fi

    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        echo "Already linked $label: $dest"
        return
    fi

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "Backing up existing $label: $dest"
        mv "$dest" "$BACKUP_DIR"
    fi

    ln -s "$src" "$dest"
    echo "Linked $src -> $dest"
}

# --------- INTERACTIVE PROGRAM INSTALLATION ---------
if [ "$IS_DEVCONTAINER" = true ]; then
    PROGRAMS=("zsh" "curl" "git" "starship")
    echo "Select programs to install (space-separated numbers, e.g., 1 3):"
    for i in "${!PROGRAMS[@]}"; do
        echo "$((i+1))) ${PROGRAMS[$i]}"
    done
    read -rp "Your choice: " -a choices

    for choice in "${choices[@]}"; do
        prog="${PROGRAMS[$((choice-1))]}"
        if [ "$prog" = "starship" ]; then
            if ! command -v starship &> /dev/null; then
                echo "Installing starship..."
                curl -sS https://starship.rs/install.sh | sh -s -- -y
            fi
        else
            if ! command -v "$prog" &> /dev/null; then
                echo "Installing $prog..."
                if command -v apt-get &> /dev/null; then
                    if [ "$(id -u)" = "0" ]; then
                        apt-get update && apt-get install -y "$prog"
                    elif command -v sudo &> /dev/null; then
                        sudo apt-get update && sudo apt-get install -y "$prog"
                    fi
                fi
            fi
        fi
    done
fi

# --------- INTERACTIVE DOTFILE LINKING ---------
# Config directories
mapfile -t ALL_CONFIGS < <(find "$DOTFILES_DIR" -maxdepth 1 -type d ! -path "$DOTFILES_DIR" -printf "%f\n")
# Dotfiles (hidden files)
mapfile -t ALL_FILES < <(find "$DOTFILES_DIR" -maxdepth 1 -type f -name ".*" -printf "%f\n")

echo "Available configuration directories:"
for i in "${!ALL_CONFIGS[@]}"; do
    echo "$((i+1))) ${ALL_CONFIGS[$i]}"
done
read -rp "Enter numbers of configs to link (space-separated): " -a config_choices

echo "Available individual files:"
for i in "${!ALL_FILES[@]}"; do
    echo "$((i+1))) ${ALL_FILES[$i]}"
done
read -rp "Enter numbers of files to link (space-separated): " -a file_choices

for choice in "${config_choices[@]}"; do
    cfg="${ALL_CONFIGS[$((choice-1))]}"
    link_path "$DOTFILES_DIR/$cfg" "$HOME/.config/$cfg" "config"
done

for choice in "${file_choices[@]}"; do
    f="${ALL_FILES[$((choice-1))]}"
    link_path "$DOTFILES_DIR/$f" "$HOME/$f" "file"
done

echo "Setup complete."
