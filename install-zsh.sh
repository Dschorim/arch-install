#!/bin/bash

paru -S --noconfirm zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting powerline-fonts

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

chsh -s /usr/bin/zsh

cp ./dotfiles/zshrc ~/.zshrc
echo "source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

paru -S --noconfirm zsh-theme-powerlevel10k-git
echo "source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc

sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -O "/usr/share/fonts/MesloLGS NF Regular.ttf"
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -O "/usr/share/fonts/MesloLGS NF Bold.ttf"
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -O "/usr/share/fonts/MesloLGS NF Italic.ttf"
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -O "/usr/share/fonts/MesloLGS NF Bold Italic.ttf"

fc-cache

echo "Alacritty needs to be restarted to apply fonts"
