source ~/.oh-my-posh.nu
hyprctl splash | cowsay

$env.config.show_banner = false
$env.config.history = {
  file_format: sqlite
  max_size: 1_000_000
  sync_on_enter: true
  isolation: true
}

alias pls = sudo
alias yeet = yay -Rns
alias adios = shutdown -h now
def cat [...args] { bat ...$args | path expand }
def ip [...args] { ^ip --color=auto ...$args }
def doxme [] { wget http://ipinfo.io/ip -qO - }
def clients [] {hyprctl clients -j | jq | from json | select class xwayland}

# Environment variables
$env.BROWSER = ".local/share/applications/ZenBrowser.desktop"
$env.CRYPTOGRAPHY_OPENSSL_NO_LEGACY = "true"
$env.HYPRSHOT_DIR = ($env.HOME | path join "Pictures" "shots")
$env.OLLAMA_KEEP_ALIVE = "-1"
$env.UV_HTTP_TIMEOUT = "300"
$env.TERMINAL = "kitty"

# Less/man page colors
$env.LESS_TERMCAP_mb = "\e[01;32m"
$env.LESS_TERMCAP_md = "\e[01;32m"
$env.LESS_TERMCAP_me = "\e[0m"
$env.LESS_TERMCAP_se = "\e[0m"
$env.LESS_TERMCAP_so = "\e[01;47;34m"
$env.LESS_TERMCAP_ue = "\e[0m"
$env.LESS_TERMCAP_us = "\e[01;36m"
$env.LESS = "-R"
$env.GROFF_NO_SGR = "1"
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
