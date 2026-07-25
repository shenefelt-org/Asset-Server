#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

username=$1

# add user interact
sudo adduser $username

# Force password change on first login
sudo passwd -e $username

echo "User '$username' created. Must change password on first login."
