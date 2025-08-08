# Main Nushell configuration

source ~/.oh-my-posh.nu
source ~/.config/nushell/env.nu
source ~/.config/nushell/aliases.nu

hyprctl splash | cowsay

# Nushell Configuration
$env.config.show_banner = false
$env.config.buffer_editor  = "nvim"

let carapace_completer = {|spans|
    carapace $spans.0 nushell ...$spans | from json
}

let fish_completer = {|spans|
    fish --command $"complete '--do-complete=($spans | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
    | update value {
        if ($in | path exists) {$'"($in | str replace "\"" "\\\"" )"'} else {$in}
    }
}

let multiple_completers = {|spans|
    let cmd = $spans.0
    if ($cmd | str starts-with 'hypr') {
        $fish_completer
    } else if $cmd in ['swww', 'ollama'] {
        $fish_completer
    } else {
        $carapace_completer
    } | do $in $spans
}


$env.config.completions.external = {
  enable: true
  completer: $multiple_completers
}
