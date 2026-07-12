#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR=$(cd "$(dirname "$0")" && pwd)
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y-%m-%d_%H-%M-%S)"

IS_DEVCONTAINER=false
if [ -f "/.dockerenv" ] || [ -n "${REMOTE_CONTAINERS:-}" ] || [ -n "${CODESPACES:-}" ] || [ -n "${DEVCONTAINER:-}" ]; then
    IS_DEVCONTAINER=true
fi

case "$(uname -s)" in
    Linux*)  OS=linux;;
    Darwin*) OS=macos;;
    *)       OS=unknown;;
esac

# --------- ARGUMENT PARSING ---------
DO_ALL=false
DO_PACKAGES=false
DO_INTERACTIVE=true

usage() {
    cat <<EOF
Usage: ./setup.sh [options]

  (no options)   Interactive menu to pick configs/files to link.
  --all          Link every config + dotfile, symlink scripts, install
                 zsh plugins. Non-interactive. Ideal for a new machine.
  --packages     Install the packages listed in ./packages.
  -h, --help     Show this help.

Flags combine, e.g.  ./setup.sh --all --packages
EOF
}

for arg in "$@"; do
    case "$arg" in
        --all)       DO_ALL=true; DO_INTERACTIVE=false;;
        --packages)  DO_PACKAGES=true; DO_INTERACTIVE=false;;
        -h|--help)   usage; exit 0;;
        *)           echo "Unknown option: $arg" >&2; usage; exit 1;;
    esac
done

echo "Dotfiles directory: $DOTFILES_DIR"
echo "OS: $OS"
echo "Devcontainer: $IS_DEVCONTAINER"
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

# --------- PACKAGE INSTALLATION ---------
install_packages() {
    local pkg_file="$DOTFILES_DIR/packages"
    [ -f "$pkg_file" ] || { echo "No packages file, skipping."; return; }

    if command -v pacman >/dev/null 2>&1; then
        echo "Installing packages with pacman..."
        # shellcheck disable=SC2046
        sudo pacman -S --needed --noconfirm $(grep -vE '^\s*(#|$)' "$pkg_file")
    elif command -v apt-get >/dev/null 2>&1; then
        echo "Installing packages with apt-get..."
        local sudo_cmd=""
        [ "$(id -u)" = "0" ] || sudo_cmd="sudo"
        $sudo_cmd apt-get update
        # shellcheck disable=SC2046
        $sudo_cmd apt-get install -y $(grep -vE '^\s*(#|$)' "$pkg_file")
    elif command -v brew >/dev/null 2>&1; then
        echo "Installing packages with brew..."
        grep -vE '^\s*(#|$)' "$pkg_file" | xargs -n1 brew install || true
    else
        echo "No supported package manager found; install packages manually:"
        cat "$pkg_file"
    fi
}

# --------- ZSH PLUGIN INSTALLATION ---------
install_zsh_plugins() {
    command -v git >/dev/null 2>&1 || { echo "git not found, skipping zsh plugins."; return; }
    local dir="$HOME/.local/share/zsh-plugins"
    mkdir -p "$dir"
    local -a repos=(
        "https://github.com/zsh-users/zsh-autosuggestions.git"
        "https://github.com/zsh-users/zsh-syntax-highlighting.git"
        "https://github.com/zsh-users/zsh-completions.git"
    )
    for repo in "${repos[@]}"; do
        local name; name=$(basename "$repo" .git)
        if [ -d "$dir/$name" ]; then
            echo "zsh plugin already present: $name"
        else
            echo "Cloning zsh plugin: $name"
            git clone --depth 1 "$repo" "$dir/$name"
        fi
    done
}

# --------- SCRIPT SYMLINKING ---------
link_scripts() {
    echo "Symlinking scripts into ~/.local/bin..."
    local f
    for f in "$DOTFILES_DIR"/scripts/*; do
        [ -f "$f" ] || continue
        link_path "$f" "$HOME/.local/bin/$(basename "$f")" "script"
    done
}

# --------- DEVCONTAINER MINIMAL INSTALL ---------
devcontainer_install() {
    local PROGRAMS=("zsh" "curl" "git" "starship")
    echo "Select programs to install (space-separated numbers, e.g., 1 3):"
    for i in "${!PROGRAMS[@]}"; do
        echo "$((i+1))) ${PROGRAMS[$i]}"
    done
    read -rp "Your choice: " -a choices

    for choice in "${choices[@]}"; do
        prog="${PROGRAMS[$((choice-1))]}"
        if [ "$prog" = "starship" ]; then
            command -v starship >/dev/null 2>&1 || curl -sS https://starship.rs/install.sh | sh -s -- -y
        else
            command -v "$prog" >/dev/null 2>&1 && continue
            if command -v apt-get >/dev/null 2>&1; then
                if [ "$(id -u)" = "0" ]; then
                    apt-get update && apt-get install -y "$prog"
                elif command -v sudo >/dev/null 2>&1; then
                    sudo apt-get update && sudo apt-get install -y "$prog"
                fi
            fi
        fi
    done
}

# --------- LINK EVERYTHING (non-interactive) ---------
link_all() {
    local d f
    for d in "$DOTFILES_DIR"/*/; do
        local name; name=$(basename "$d")
        [ "$name" = "scripts" ] && continue
        link_path "${d%/}" "$HOME/.config/$name" "config"
    done
    for f in "$DOTFILES_DIR"/.*; do
        [ -f "$f" ] || continue
        local base; base=$(basename "$f")
        case "$base" in
            .|..|.git|.gitignore|.gitmodules) continue;;
        esac
        link_path "$f" "$HOME/$base" "file"
    done
    link_scripts
}

# --------- INTERACTIVE DOTFILE LINKING ---------
interactive_link() {
    mapfile -t ALL_CONFIGS < <(find "$DOTFILES_DIR" -maxdepth 1 -type d ! -path "$DOTFILES_DIR" ! -name scripts -printf "%f\n")
    mapfile -t ALL_FILES < <(find "$DOTFILES_DIR" -maxdepth 1 -type f -name ".*" ! -name ".gitignore" ! -name ".gitmodules" -printf "%f\n")

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

    read -rp "Symlink scripts into ~/.local/bin? [Y/n] " ans
    case "${ans:-y}" in [Yy]*|"") link_scripts;; esac
}

# --------- MAIN ---------
echo "Backing up replaced files to: $BACKUP_DIR"

if [ "$DO_PACKAGES" = true ]; then
    install_packages
fi

if [ "$IS_DEVCONTAINER" = true ] && [ "$DO_ALL" = false ]; then
    devcontainer_install
fi

if [ "$DO_ALL" = true ]; then
    install_zsh_plugins
    link_all
elif [ "$DO_INTERACTIVE" = true ]; then
    install_zsh_plugins
    interactive_link
fi

# Drop the backup dir if nothing was moved into it.
rmdir "$BACKUP_DIR" 2>/dev/null && echo "No files needed backing up." || true

echo "Setup complete."
