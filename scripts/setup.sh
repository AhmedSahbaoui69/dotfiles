#!/bin/bash

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Check if yay is installed
if ! command -v yay &> /dev/null; then
    log "yay is not installed. Installing yay..."
    
    # Ensure base-devel and git are installed
    log "Installing necessary packages..."
    sudo pacman -S --needed --noconfirm base base-devel git
    
    # Install yay
    log "Cloning the yay repository..."
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin || { log "Failed to change directory to /tmp/yay-bin"; exit 1; }
    log "Building and installing yay..."
    makepkg -si --noconfirm
    
    # Cleanup
    log "Cleaning up..."
    cd ~
    rm -rf /tmp/yay-bin
    
    log "yay installation complete."
fi

yay -S \
    awesome-terminal-fonts \
    bibata-cursor-theme \
    blueman \
    brightnessctl \
    btop \
    cava \
    cliphist \
    cowsay \
    cpupower \
    ctop \
    duf \
    eog \
    eza \
    fastfetch \
    firewalld \
    fish \
    fisher \
    flatpak \
    gamemode \
    gnome-text-editor \
    hyprland \
    hyprlock \
    hyprpaper \
    hyprshot \
    iio-hyprland-git \
    inotify-tools \
    jq \
    kdeconnect \
    kitty \
    kvantum-theme-catppuccin-git \
    kwalletmanager \
    kwayland-integration \
    mako \
    nautilus \
    nautilus-copy-file-contents-git \
    nautilus-gnome-disks \
    neovim \
    network-manager-applet \
    noto-fonts-emoji \
    nwg-look \
    ocrdesktop \
    onefetch \
    otf-font-awesome \
    pamixer \
    polkit-gnome \
    pulsemixer \
    qpwgraph \
    qt5ct \
    qt6ct \
    ranger \
    rofi-wayland \
    tela-circle-icon-theme-blue \
    tesseract-data-ara \
    tesseract-data-fra \
    tesseract-data-eng \
    thorium-browser-bin \
    zen-browser-bin \
    tldr \
    totem \
    ttf-bitstream-vera \
    ttf-dejavu \
    ttf-font-awesome \
    ttf-jetbrains-mono-git \
    ttf-jetbrains-mono-nerd \
    ttf-liberation \
    ttf-noto-nerd \
    ttf-opensans \
    uv \
    visual-studio-code-bin \
    vlc \
    waybar \
    wl-clipboard \
    wlsunset \
    xdg-desktop-portal-gtk \
    xdg-desktop-portal-hyprland 