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

printf "Package install complete.. service setup start\n"

printf "Granting $USER RWX perms on /srv\n\n"
setfacl -R -m u:$USER:rwx /srv/
# setup f_share dir and acl
printf "Setting up file share directory and ACLs\n\n"
mkdir -p /srv/f_share/
cd /srv/f_share
printf "populating file share with assets from assets.shenefelt.org.."

curl -sSL https://assets.shenefelt.org/setup.tar.gz | tar -xz -C /srv/f_share
printf "downloaded and extracted assets\n\n"

printf "Creating shared files group for Samba Server\n\n"
groupadd sharedfiles
setfacl -R -m g:sharedfiles:rwx,d:g:sharedfiles:rwx /srv
printf "acl set on sharedfiles group $(getfacl /srv/f_share/)\n\n"

printf "setting up samba user\n\n"
smbpasswd -a $USER
usermod -aG sharedfiles $USER
printf "Success! Sama Share user $USER added to sharedfiles\n\n"

OTHER_SCRIPTS=(
  "/srv/f_share/assets/setup_neovim_with_lazyvim.sh"
  "/srv/f_share/assets/install-1pass-beta.sh"
)

# Run the external scripts
for SCRIPT in "${OTHER_SCRIPTS[@]}"; do
  if [ -f "$SCRIPT" ]; then
    echo "--> Running external script: $SCRIPT"
    chmod +x "$SCRIPT"
    bash "$SCRIPT"
    printf "Install complete.. continue\n"
  else
    echo "Warning: Script $SCRIPT not found. Skipping." >&2
  fi
done



echo "complete system setup as _shenefelt"
