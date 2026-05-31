# My Minimal Hyprland Dotfiles

![screenshot-placeholder](httpsmisc/screenshot.png)

These are my personal dotfiles for a minimal Hyprland setup. The configurations are curated from various sources across the internet, tailored to my workflow.

## Features

- **Window Manager:** [Hyprland](https://hyprland.org/)
- **Bar:** [Waybar](https://github.com/Alexays/Waybar)
- **Launcher/Search:** [walker](https://github.com/abenz1267/walker)
- **Terminal:** [kitty](https://sw.kovidgoyal.net/kitty/) & [foot](https://codeberg.org/dnkl/foot)
- **Editor:** [Neovim](https://neovim.io/) & [Helix](https://helix-editor.com/)
- **Shell:** [Zsh](https://www.zsh.org/) with [Starship](https://starship.rs/) prompt
- **Notification Daemon:** [Mako](https://github.com/emersion/mako)
- **PDF Viewer:** [Zathura](https://pwmt.org/projects/zathura/)
- **Multiplexer:** [tmux](https://github.com/tmux/tmux/wiki)

## Installation

1.  **Clone the repository:**

    ```sh
    git clone https://github.com/your-username/dotfiles.git
    cd dotfiles
    ```

2.  **Run the setup script:**

    The `setup.sh` script will back up any existing configurations and create symlinks for the new ones.

    ```sh
    ./setup.sh
    ```

3.  **Check the setup:**

    ```sh
    doctor
    check
    ```

## Dependencies

To use these dotfiles, you'll need to have the following software installed:

- `hyprland`
- `waybar`
- `kitty`
- `foot`
- `neovim`
- `helix`
- `zsh`
- `starship`
- `mako`
- `zathura`
- `walker`
- `tmux`
- `wl-clipboard`
- `git`

## Local Paths

Common script paths can be overridden with environment variables:

- `DOTFILES_BOOKMARKS_FILE`
- `DOTFILES_OTP_LIST`
- `DOTFILES_PDF_GLOB`
- `DOTFILES_PDF_SEARCH_ROOT`
- `DOTFILES_SCREENSHOT_DIR`

## Repository Structure

The repository is organized as follows:

- **Configuration files:** Most configuration files are located in directories named after the application (e.g., `nvim/`, `hypr/`).
- **`setup.sh`:** The installation script for symlinking the dotfiles.
- **`scripts/`:** A collection of utility scripts.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
