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

set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
pyenv init - | source

set -gx BROWSER /usr/bin/zen-browser
set -gx CRYPTOGRAPHY_OPENSSL_NO_LEGACY true
