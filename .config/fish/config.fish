if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -U fish_greeting
hyprctl splash | cowsay 

alias pls "sudo"
alias yeet "yay -Rns"
alias adios "shutdown -h now" 
alias ls "eza"
alias cat "bat"

set -gx BROWSER .local/share/applications/ZenBrowser.desktop
set -gx CRYPTOGRAPHY_OPENSSL_NO_LEGACY true
set -gx HYPRSHOT_DIR $HOME/Pictures/shots

set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
