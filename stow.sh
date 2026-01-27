#!/usr/bin/env fish

# Stow all dotfiles packages
set packages config local icons themes

cd (dirname (status -f))

for package in $packages
    echo "Stowing $package..."
    stow $package
end

echo "✓ All packages stowed successfully!"
