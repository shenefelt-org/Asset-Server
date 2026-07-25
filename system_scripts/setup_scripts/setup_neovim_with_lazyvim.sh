#!/bin/bash
# 1. Install Neovim
sudo snap install nvim --classic

# 2. Clone a starter config (LazyVim is the easiest)
git clone https://github.com/LazyVim/starter ~/.config/nvim

echo "Complete! nvim with lazyvim manager installed please run nvim in the terminal for autosetup"
