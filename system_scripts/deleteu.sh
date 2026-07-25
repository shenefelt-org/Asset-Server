#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

username=$1

# Check if user exists
if ! id "$username" &>/dev/null; then
    echo "Error: User '$username' does not exist"
    exit 1
fi

# Confirm deletion
echo "WARNING: This will delete user '$username' and ALL their files!"
read -p "Are you sure? (type 'yes' to confirm): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Cancelled."
    exit 0
fi

# Kill any running processes by this user
sudo killall -9 -u $username 2>/dev/null

# Delete user and home directory
sudo userdel -r $username

echo "User '$username' and all their files have been deleted."
