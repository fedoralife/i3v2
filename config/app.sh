#!/bin/bash

echo "Welcome to the application installer"
echo "Do you wish to continue"

read -p "Enter 1 to contine any key else to exit " num

if [ $num == 1 ]; then
    sudo pacman -Syu
    sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
    if ! pacman -Q fzf &>/dev/null; then
        sudo pacman -S --noconfirm fzf
    fi
    if ! pacman -Q picom &>/dev/null; then
        sudo pacman -S --noconfirm picom
    fi
    if ! pacman -Q rofi &>/dev/null; then
        sudo pacman -S --noconfirm rofi
    fi
    if ! pacman -Q polyabr &>/dev/null; then
        sudo pacman -S --noconfirm polybar
    fi
    if ! pacman -Q thunar &>/dev/null; then
        sudo pacman -S --noconfirm thunar
    fi
    if ! pacman -Q neovim &>/dev/null; then

        sudo pacman -S --noconfirm neovim
    fi

    yay -S --noconfirm scort
    if ! pacman -Q neofetch &>/dev/null; then
        sudo pacman -S --noconfirm neofetch
    fi
    if ! pacman -Q kitty &>/dev/null; then
        sudo pacman -S --noconfirm kitty
    fi
    if ! pacman -Q gimp &>/dev/null; then
        sudo pacman -S --noconfirm gimp
    fi
    if ! pacman -Q obsidian &>/dev/null; then
        sudo pacman -S --noconfirm obsidian
    fi
    if ! pacman -Q vlc >&/dev/null; then
        sudo pacman -S --noconfirm vlc
    fi
    if ! pacman -Q kdenlive >&/dev/null; then
        sudo pacman -S --noconfirm kdenlive
    fi
    if ! pacman -Q libreoffice >&/dev/null; then
        sudo pacman -S --noconfirm libreoffice
    fi
    if ! pacman -Q obs-studio >&/dev/null; then
        sudo pacman -S --noconfirm obs-studio
    fi
    if ! pacman -Q firefox >&/dev/null; then
        sudo pacman -S --noconfirm firefox
    fi
    if ! pacman -Q zsh; then
        sudo pacman -S --noconfirm zsh
    fi
    if ! pacman -Q i3-wm; then
        sudo pacman -S --noconfirm i3-wm
    fi
    if ! pacman -Q sddm; then
        sudo pacman -S --noconfirm sddm
    fi

    yay -S --noconfirm ttf-font-awesome
else
    echo "Not choosen"
fi

echo "Do you want my cofig files"
read -p "Enter 1 to contiue" option

if [ $option == 1 ]; then
    cp -r config/* ~/.config/
    cp -r nvim ~/.config/
    echo "Copying Complete"
    cp -r ./config/.tmux.conf ~/
else
    echo "Not choosen"
fi

echo "Do you want my wallpapers"
read -p "Enter 1 to contiue" option

if [ $option == 1 ]; then
    cp -r wallpapers/* ~/Pictures/
    echo "Copying Complete"
else
    echo "Not choosen"
fi

echo "Do you want my zsh"
read -p "Enter 1 to contiue" option
if [ $option = 1 ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Not selcted"
fi
cp -r .zshrc ~/
cp -r scripts ~/
