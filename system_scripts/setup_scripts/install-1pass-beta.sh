#!/usr/bin/env bash

# Exit the script immediately if any command fails
set -e

echo "🧹 Cleaning up old keyring and repository files..."
sudo rm -f /usr/share/keyrings/1password-archive-keyring.gpg
sudo rm -f /etc/apt/sources.list.d/1password.list

echo "Downloading and importing the 1Password GPG key..."
sudo wget -O- https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --yes -o /usr/share/keyrings/1password-archive-keyring.gpg

echo "Adding the 1Password Beta repository source..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) beta main" | sudo tee /etc/apt/sources.list.d/1password.list

echo "Updating package sources and installing 1Password CLI..."
sudo apt update && sudo apt install 1password-cli

echo "Done! 1Password CLI Beta has been successfully installed."
