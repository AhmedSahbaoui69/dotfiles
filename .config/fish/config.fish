if status is-interactive
    hyprctl splash | cowsay
end

alias h "eval (history | fzf | sed 's/^[ ]*[0-9]*[ ]*//')"

alias pls "sudo"
alias yeet "yay -Rns"
alias adios "shutdown -h now" 
alias ls "eza"
alias cat "bat --theme Dracula"
alias ip "ip --color=auto"
alias doxme "wget http://ipinfo.io/ip -qO -"

set -gx BROWSER .local/share/applications/ZenBrowser.desktop
set -gx CRYPTOGRAPHY_OPENSSL_NO_LEGACY true
set -gx HYPRSHOT_DIR $HOME/Pictures/shots
set -gx OLLAMA_KEEP_ALIVE -1
set -gx UV_HTTP_TIMEOUT 300

set -x LESS_TERMCAP_mb \e'[01;32m'
set -x LESS_TERMCAP_md \e'[01;32m'
set -x LESS_TERMCAP_me \e'[0m'
set -x LESS_TERMCAP_se \e'[0m'
set -x LESS_TERMCAP_so \e'[01;47;34m'
set -x LESS_TERMCAP_ue \e'[0m'
set -x LESS_TERMCAP_us \e'[01;36m'
set -x LESS -R
set -x GROFF_NO_SGR 1
