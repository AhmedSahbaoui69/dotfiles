#!/usr/bin/env fish

set dotdir (realpath ~/dotfiles)
set symfile $dotdir/sym_paths.txt

for path in (cat $symfile)
    # Absolute path inside ~/dotfiles
    set src $dotdir/$path
    # Destination in ~/
    set dest (realpath ~)/$path
    # Ensure parent directory exists
    mkdir -p (dirname $dest)
    # Create symlink (force overwrite if exists)
    ln -sfn $src $dest
    echo "Linked $src -> $dest"
end

