#!/bin/bash

# Check if a username was provided
if [ -z "$1" ]; then
  echo "Error: No username provided."
  echo "Usage: $0 <username>"
  exit 1
fi

USERNAME=$1

# Verify the script is running with root/sudo privileges
if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run this script with sudo."
  exit 1
fi

# Check if the user has an active session before attempting to terminate
if ! loginctl list-users | grep -q -w "$USERNAME"; then
  echo "User '$USERNAME' does not have an active session."
  exit 1
fi

# Terminate the user session
echo "Logging out user: $USERNAME..."
loginctl terminate-user "$USERNAME"

if [ $? -eq 0 ]; then
  echo "Successfully logged out $USERNAME."
else
  echo "Failed to log out $USERNAME."
fi
