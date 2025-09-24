#!/usr/bin/env bash

# Colors
dim="\033[2m"
reset="\033[0m"
green="\033[32m"
blue="\033[34m"

# Helper function to link items recursively
link_items_recursive() {
    local src="$1"
    local dest="$2"

    if [ ! -e "$src" ]; then
        echo -e "${dim}Skipping $src (does not exist)${reset}"
        return
    fi

    if [ -d "$src" ]; then
        mkdir -p "$dest"
        for item in "$src"/*; do
            name=$(basename "$item")
            link_items_recursive "$item" "$dest/$name"
        done
    else
        if [ -L "$dest" ]; then
            # Check if symlink already points to the correct source
            existing_target=$(readlink "$dest")
            if [ "$existing_target" = "$src" ]; then
                echo -e "${dim}Skipping $dest (already linked)${reset}"
                return
            else
                rm "$dest"
                echo -e "${green}Linked${reset} $dest ${dim}(replaced)${reset}"
            fi
        elif [ -e "$dest" ]; then
            rm -rf "$dest"
            echo -e "${green}Linked${reset} $dest ${dim}(replaced)${reset}"
        else
            echo -e "${green}Linked${reset} $dest"
        fi
        ln -s "$src" "$dest"
    fi
}

### --- Part 1: Symlink dotfiles recursively ---
dirs_to_link=(".config" ".local/share" ".themes" ".icons")

for d in "${dirs_to_link[@]}"; do
    src_dir="$HOME/dotfiles/$d"
    dest_dir="$HOME/$d"
    link_items_recursive "$src_dir" "$dest_dir"
done

echo -e "✅ ${blue}Dotfiles synced${reset}"

### --- Part 2: Firefox chrome setup ---
src="$HOME/dotfiles/chrome"
profiles=(~/.zen/*)

if [ ${#profiles[@]} -eq 0 ]; then
  echo "⚠️  No profiles found in ~/.zen/"
  exit 0
fi

echo -e "\n${blue}Select a Firefox/Zen profile:${reset}"
for i in "${!profiles[@]}"; do
  echo "[$i] $(basename "${profiles[$i]}")"
done

read -p "Enter number: " choice
if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -ge "${#profiles[@]}" ]; then
  echo "❌ Invalid choice"
  exit 1
fi

dest="${profiles[$choice]}/chrome"
mkdir -p "$dest"

for item in "custom-modules" "userChrome.css"; do
  src_item="$src/$item"
  dest_item="$dest/$item"

  if [ -e "$src_item" ]; then
    if [ -e "$dest_item" ]; then
        echo -e "${dim}Skipping $item (already installed)${reset}"
        continue
    fi
    cp -r "$src_item" "$dest_item"
    echo -e "${green}Installed${reset} $item ${dim}(to $(basename "${profiles[$choice]}"))${reset}"
  fi
done

echo -e "✅ ${blue}Zen customizations installed${reset}"
