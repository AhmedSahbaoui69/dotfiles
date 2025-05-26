# Main Nushell configuration

source ~/.oh-my-posh.nu
source ~/.config/nushell/env.nu
source ~/.config/nushell/aliases.nu

hyprctl splash | cowsay

# Nushell Configuration
$env.config.show_banner = false
$env.config.history = {
  file_format: sqlite
  max_size: 1_000_000
  sync_on_enter: true
  isolation: true
}

