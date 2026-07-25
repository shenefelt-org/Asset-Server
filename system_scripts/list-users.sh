#!/bin/bash

echo "════════════════════════════════════════════════════════════════════════"
printf "%-15s %-15s %-10s %-30s\n" "USERNAME" "UID" "GID" "GROUPS"
echo "════════════════════════════════════════════════════════════════════════"

# Get all users (UID >= 1000 for regular users, or change to >= 0 for all)
awk -F: '$3 >= 1000 {print $1, $3, $4}' /etc/passwd | while read username uid gid; do
    groups_list=$(groups $username 2>/dev/null | cut -d: -f2 | xargs)
    printf "%-15s %-15s %-10s %-30s\n" "$username" "$uid" "$gid" "$groups_list"
done

echo "════════════════════════════════════════════════════════════════════════"
