#!/bin/bash

paru -S --noconfirm zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting powerline-fonts

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

chsh -s /usr/bin/zsh

cp ./dotfiles/zshrc ~/.zshrc
echo "source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc