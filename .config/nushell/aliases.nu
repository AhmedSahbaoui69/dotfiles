# Aliases

alias pls = sudo
alias yeet = yay -Rns
alias adios = shutdown -h now
def cat [...args] { bat ...$args | path expand }
def ip [...args] { ^ip --color=auto ...$args }
def doxme [] { wget http://ipinfo.io/ip -qO - }
def clients [] {hyprctl clients -j | jq | from json | select class xwayland}
