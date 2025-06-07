# Aliases

alias pls = sudo
alias yeet = yay -Rns
alias adios = shutdown -h now
def cat [...args] { bat ...$args}
def ip [...args] { ^ip --color=auto ...$args }
def doxme [] { wget http://ipinfo.io/ip -qO - }
def clients [] {hyprctl clients -j | jq | from json | select class xwayland}
def grep [...args] { rg --color=auto ...$args }
def ocr [
    path_or_url?: string  # optional path or URL
    --cl                  # use latest image from cliphist
] {
    let tmpimg = "/tmp/ocr_input.png"

    let input = if $cl {
        # Get ID of the latest image from cliphist
        cliphist list | lines | first | cliphist decode | save -f $tmpimg
        $tmpimg
    } else if $path_or_url == null {
        # Get latest file from screenshots folder
        ls ~/Pictures/shots/ | where type == "file" | sort-by modified | last | get name
    } else if $path_or_url =~ '^https?://' {
        http get $path_or_url | save -f $tmpimg
        $tmpimg
    } else {
        $path_or_url
    }

    tesseract $input "/tmp/hello" | complete
    let text = cat "/tmp/hello.txt"
    $text | wl-copy --primary
    $text
}

