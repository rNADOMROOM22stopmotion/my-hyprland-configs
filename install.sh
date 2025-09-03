#!/bin/bash
set -e  # Exit on error

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR/dotfiles"
CONFIG_DIR="$DOTFILES_DIR/.config"
PACKAGES_FILE="$SCRIPT_DIR/packages/installed_packages.txt"

# Check if yay is installed, install if missing
install_yay() {
    if ! command -v yay &>/dev/null; then
        echo "yay not found. Installing..."
        sudo pacman -S --needed --noconfirm git base-devel
        tmpdir=$(mktemp -d)
        git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
        cd "$tmpdir/yay"
        makepkg -si --noconfirm
        cd "$SCRIPT_DIR"
        rm -rf "$tmpdir"
    else
        echo "yay is already installed."
    fi
}

# Install packages from the list
install_packages() {
    if [[ -f "$PACKAGES_FILE" ]]; then
        echo "Installing packages from $PACKAGES_FILE..."
        yay -S --needed --noconfirm - < "$PACKAGES_FILE"
    else
        echo "Error: $PACKAGES_FILE not found!"
        exit 1
    fi
}

# Copy dotfiles to ~/.config
copy_dotfiles() {
    if [[ -d "$CONFIG_DIR" ]]; then
        echo "Copying dotfiles into ~/.config..."
        mkdir -p "$HOME/.config"
        cp -rT "$CONFIG_DIR" "$HOME/.config"
    else
        echo "Error: $CONFIG_DIR not found!"
        exit 1
    fi
}

# Run steps
install_yay
install_packages
copy_dotfiles

echo "Setup complete!!"
echo " "
echo"--------------------------------------"
echo "For setting wallpaper, mkdir ~/Themes/wallpapers and put any wallpaper you want"
echo "edit the ~/.config/hypr/hyprpaper.conf and specify the wallpaper name"
echo " "
echo " "
echo "Refer the spicetify themes guide on github: https://github.com/spicetify/spicetify-themes to customize spotify"

