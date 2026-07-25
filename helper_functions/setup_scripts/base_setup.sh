#!/usr/bin/env bash

set -e

PACKAGES=(
  "snap"
  "redis"
  "nginx"
  "ufw"
  "samba"
  "acl"
)

# check sudo perms
if [ "$EUID" -ne 0 ]; then
  echo "Non sudo user terminating please run 'sudo ./base_setup.sh'" >&2
  exit 1
fi

# setup f_share dir and acl
mkdir -p /srv/f_share/

sudo setfacl -R -m g:sharedfiles:rwx,d:g:sharedfiles:rwx /srv
printf "acl set on sharedfiles group $(getfacl srv/f_share/)\n\n"
printf "setting up samba user\n\n"
sudo smbpasswd -a $USER
sudo usermod -aG sharedfiles $USER
printf "Success! Sama Share user $USER added to sharedfiles\n\n"

OTHER_SCRIPTS=(
  "/srv/f_share/system_scripts/setup_scripts/setup_neovim_with_lazyvim.sh"
  "/srv/f_share/system_scripts/setup_scripts/install-1pass-beta.sh"
  "/srv/f_share/system_scripts/setup_scripts/"
)

# Run the external scripts
for SCRIPT in "${OTHER_SCRIPTS[@]}"; do
  if [ -f "$SCRIPT" ]; then
    printf "--> Running external script: $SCRIPT\n"
    chmod +x "$SCRIPT"
    bash "$SCRIPT"
    printf "Install complete.. continue\n"
  else
    echo "Warning: Script $SCRIPT not found. Skipping." >&2
  fi
done

printf "Installing system packages.. first lets update\n"

apt-get update -y
printf "Update complete\n\n exec packages\n\n"

for PACKAGE in "${PACKAGES[@]}"; do
  if dpkg -s "$PACKAGE" >/dev/null 2>&1; then
    echo "--> $PACKAGE installed skipping"
    echo ""
  else
    echo "Installing --> $PACKAGE"
    DEBIAN_FRONTEND=noninteractive apt-get install -y "$PACKAGE"
  fi
done

echo "complete system setup as _shenefelt"
