# Environment Variables 

# Man Page Colors
$env.LESS_TERMCAP_mb = "\e[01;32m"
$env.LESS_TERMCAP_md = "\e[01;32m"
$env.LESS_TERMCAP_me = "\e[0m"
$env.LESS_TERMCAP_se = "\e[0m"
$env.LESS_TERMCAP_so = "\e[01;47;34m"
$env.LESS_TERMCAP_ue = "\e[0m"
$env.LESS_TERMCAP_us = "\e[01;36m"
$env.LESS = "-R"
$env.GROFF_NO_SGR = "1"

# Defaults 
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.TERMINAL = "kitty"
$env.BROWSER = ".local/share/applications/ZenBrowser.desktop"

# Misc
$env.CRYPTOGRAPHY_OPENSSL_NO_LEGACY = "true"
$env.HYPRSHOT_DIR = ($env.HOME | path join "Pictures" "shots")
$env.OLLAMA_KEEP_ALIVE = "-1"
$env.UV_HTTP_TIMEOUT = "300"
