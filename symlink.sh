#!/usr/bin/env fish

set dotdir ~/dotfiles
set symfile $dotdir/sym_paths.txt

for path in (cat $symfile)
    # Absolute path inside ~/dotfiles
    set src (realpath $path)
    # Remove ~/dotfiles/ prefix
    set rel (string replace -r "^$dotdir/" "" $src)
    # Destination in ~/
    set dest ~/$rel
    # Ensure parent directory exists
    mkdir -p (dirname $dest)
    # Create symlink (force overwrite if exists)
    ln -sfn $src $dest
    echo "Linked $src -> $dest"
end

