#!/usr/bin/env fish

# Unstow all dotfiles packages
set packages config local icons themes

cd (dirname (status -f))

for package in $packages
    echo "Unstowing $package..."
    stow -D $package
end

echo "✓ All packages unstowed successfully!"
