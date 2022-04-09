#!/bin/bash

paru -S --noconfirm zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting

cp ./dotfiles/zshrc ~/.zshrc
echo "source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
