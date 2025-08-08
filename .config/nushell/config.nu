# Main Nushell configuration

source ~/.oh-my-posh.nu
source ~/.config/nushell/env.nu
source ~/.config/nushell/aliases.nu

^ssh-agent -c
    | lines
    | first 2
    | parse "setenv {name} {value};"
    | transpose -r
    | into record
    | load-env

hyprctl splash | cowsay

# Nushell Configuration
$env.config.show_banner = false
$env.config.history = {
  file_format: sqlite
  max_size: 1_000_000
  sync_on_enter: true
  isolation: true
}

let carapace_completer = {|spans|
    carapace $spans.0 nushell ...$spans | from json
}

$env.config.completions.external = {
  enable: true
  completer: $carapace_completer
}
