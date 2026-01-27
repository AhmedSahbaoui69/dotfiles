function __user_host
    set -l content
    if [ (id -u) = 0 ]

        echo -n (set_color --bold red)
    else
        echo -n (set_color --bold green)
    end
    echo -n $USER@(hostname|cut -d . -f 1) (set color normal)
end

function __current_path
    echo -n (set_color --bold blue) (pwd) (set_color normal)
end

function _git_branch_name
    echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _git_is_dirty
    echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function __git_status
    if [ (_git_branch_name) ]
        set -l git_branch (_git_branch_name)

        if [ (_git_is_dirty) ]
            set git_info '‹'$git_branch"*"'›'
        else
            set git_info '‹'$git_branch'›'
        end

        echo -n (set_color yellow) $git_info (set_color normal)
    end
end

function __python_version
    # Check if Python is installed
    if not type -q python
        return
    end

    # Get Python version
    set -l python_version (python -V 2>&1 | string split ' ')[2]

    # Initialize environment name
    set -l env_name

    # Check for Conda environment
    if test -n "$CONDA_DEFAULT_ENV"
        set env_name "$CONDA_DEFAULT_ENV"
        # Check for Python virtual environment
    else if test -n "$VIRTUAL_ENV"
        set env_name (basename "$VIRTUAL_ENV")
    end

    # Format output
    if test -n "$env_name"
        echo -n (set_color red) ‹"$env_name $python_version"› (set_color normal)
    else
        echo -n (set_color red) ‹"$python_version"› (set_color normal)
    end
end

function fish_prompt
    echo -n (set_color white)"╭─"(set_color normal)
    __user_host
    __current_path
    __git_status
    __python_version # Display Python info
    echo -e ''
    echo (set_color white)"╰─"(set_color --bold white)"\$ "(set_color normal)
end

function fish_right_prompt
    set -l st $status

    if [ $st != 0 ]

        echo (set_color red) ↵ $st(set_color normal)
    end
end
