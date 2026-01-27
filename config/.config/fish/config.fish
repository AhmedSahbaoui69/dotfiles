if status is-interactive
    fortune -s | cowsay
end

alias h "eval (history | fzf | sed 's/^[ ]*[0-9]*[ ]*//')"

alias pls sudo
alias adios "shutdown -h now"
alias ls='eza -al --color=always --group-directories-first --icons'
alias cat "bat --theme Dracula"
alias grep='grep --color=auto'
alias ip "ip --color=auto"
alias doxme "wget http://ipinfo.io/ip -qO -"
alias clients='niri msg --json windows | jq "map({app_id: .\"app_id\", pid: .pid})"'

set -gx BROWSER /usr/bin/helium-browser
set -gx EDITOR nvim
set -gx CRYPTOGRAPHY_OPENSSL_NO_LEGACY true
set -gx HYPRSHOT_DIR $HOME/Pictures/shots
set -gx OLLAMA_KEEP_ALIVE -1
set -gx UV_HTTP_TIMEOUT 300
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
set -U fish_greeting ""

set -x LESS_TERMCAP_mb \e'[01;32m'
set -x LESS_TERMCAP_md \e'[01;32m'
set -x LESS_TERMCAP_me \e'[0m'
set -x LESS_TERMCAP_se \e'[0m'
set -x LESS_TERMCAP_so \e'[01;47;34m'
set -x LESS_TERMCAP_ue \e'[0m'
set -x LESS_TERMCAP_us \e'[01;36m'
set -x LESS -R
set -x GROFF_NO_SGR 1
