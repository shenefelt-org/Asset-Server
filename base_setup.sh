#!/usr/bin/env bash

# --- Strict Error Handling Flags ---
# -e: Exit immediately if a command fails
# -u: Exit if an unset variable is accessed
# -o pipefail: Ensures 'curl | tar' fails if curl errors out (not just tar)
set -euo pipefail

# Print exact line number when an unexpected error triggers an exit
trap 'echo "CRITICAL ERROR: Command failed at line $LINENO with exit code $?" >&2' ERR

# --- User Detection ---
# When using 'sudo', $USER becomes 'root'. 
# $SUDO_USER captures the actual human account running the script.
REAL_USER="${SUDO_USER:-$USER}"

if [ "$EUID" -ne 0 ]; then
  echo "Error: Non-sudo user. Please run with 'sudo ./base_setup.sh'" >&2
  exit 1
fi

if [ "$REAL_USER" = "root" ]; then
  echo "Warning: Script is running as pure root (not via sudo). Target user will be 'root'." >&2
fi

# Package list (Fixed: 'snap' package in APT is actually 'snapd')
PACKAGES=(
  "snapd"
  "redis"
  "nginx"
  "ufw"
  "samba"
  "acl"
)

printf "Installing system packages... running update first\n"
apt-get update -y
printf "Update complete.\n\n"

for PACKAGE in "${PACKAGES[@]}"; do
  if dpkg -s "$PACKAGE" >/dev/null 2>&1; then
    echo "--> $PACKAGE is already installed, skipping."
  else
    echo "Installing --> $PACKAGE"
    DEBIAN_FRONTEND=noninteractive apt-get install -y "$PACKAGE"
  fi
done

printf "\nPackage installation complete. Starting service setup...\n"

# Set ACL for the actual non-root user
printf "Granting %s RWX permissions on /srv\n\n" "$REAL_USER"
setfacl -R -m u:"$REAL_USER":rwx /srv/

# Setup file share directory
printf "Setting up file share directory and ACLs...\n"
mkdir -p /srv/f_share/

printf "Populating file share with assets from assets.shenefelt.org...\n"
# '-f' makes curl exit with code 22 on 404/500 errors so tar doesn't attempt to extract an HTML error page
curl -fsSL https://assets.shenefelt.org/setup.tar.gz | tar -xz -C /srv/f_share
printf "Successfully downloaded and extracted assets.\n\n"

printf "Creating sharedfiles group for Samba Server...\n"
# Safely create group if it doesn't exist (prevents script crash on re-runs)
if ! getent group sharedfiles >/dev/null 2>&1; then
  groupadd sharedfiles
fi

setfacl -R -m g:sharedfiles:rwx,d:g:sharedfiles:rwx /srv
printf "ACL set on sharedfiles group:\n%s\n\n" "$(getfacl /srv/f_share/)"

printf "Setting up Samba user for %s...\n" "$REAL_USER"
smbpasswd -a "$REAL_USER"
usermod -aG sharedfiles "$REAL_USER"
printf "Success! Samba share user '%s' added to 'sharedfiles' group.\n\n" "$REAL_USER"

OTHER_SCRIPTS=(
  "/srv/f_share/assets/setup_neovim_with_lazyvim.sh"
  "/srv/f_share/assets/install-1pass-beta.sh"
)

# Run external scripts safely
for SCRIPT in "${OTHER_SCRIPTS[@]}"; do
  if [ -f "$SCRIPT" ]; then
    echo "--> Running external script: $SCRIPT"
    chmod +x "$SCRIPT"
    bash "$SCRIPT"
    printf "Script %s complete.\n\n" "$SCRIPT"
  else
    echo "Warning: Script $SCRIPT not found. Skipping." >&2
  fi
done

echo "System setup complete for $REAL_USER!"