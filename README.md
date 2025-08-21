# Dotfiles Setup Guide


### Install `yay` (AUR Helper)

If you don't have `yay` installed yet:

```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## Install Fonts

```bash
yay -Syu awesome-terminal-fonts cantarell-fonts noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra otf-font-awesome ttf-bitstream-vera ttf-dejavu ttf-jetbrains-mono-git ttf-jetbrains-mono-nerd ttf-liberation ttf-noto-nerd ttf-opensans woff2-font-awesome
```

## Install Necessary Packages

```bash
yay -Syu nushell mako tofi waylock waybar swww wayneko-git kdeconnect neovim nautilus pulsemixer btop network-manager-applet blueman polycat nwg-look qt5ct qt6ct kvantum fish carapace hyprshot cava gsimplecal fastfetch cpupower lm_sensors visual-studio-code-bin firefox zsync flatpak uv docker hyprpicker gromit-mpx cliphist qbittorrent qpwgraph lazygit nwg-dock-hyprland wvkbd iio-hyprland wlsunset
```

## Install Zen Browser

``` bash
bash <(curl https://updates.zen-browser.app/appimage.sh)
```

## Install flatpak apps
```bash 
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```
```bash
flatpak install com.usebottles.bottles org.onlyoffice.desktopeditors io.github.Soundux com.stremio.Stremio
```

## Create symbolic links of `.config`
```bash
find ~/dotfiles/.config -type f -exec bash -c 'f="{}"; d="$HOME/.config/${f#"$HOME/dotfiles/.config/"}"; mkdir -p "$(dirname "$d")"; ln -sf "$f" "$d"' \;
```
