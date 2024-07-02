if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -U fish_greeting
hyprctl splash | cowsay 


set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

pyenv init - | source
