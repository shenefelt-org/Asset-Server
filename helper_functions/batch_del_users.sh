#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <file.txt>"
    echo "File should contain one username per line"
    exit 1
fi

filename=$1

# Check if file exists
if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' not found"
    exit 1
fi

# Show users to be deleted
echo "Users to be deleted:"
cat "$filename"
echo ""

read -p "Are you sure? (type 'yes' to confirm): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Cancelled."
    exit 0
fi

# Delete each user
while IFS= read -r username; do
    # Skip empty lines and comments
    [[ -z "$username" || "$username" =~ ^# ]] && continue
    
    if id "$username" &>/dev/null; then
        echo "Deleting user: $username"
        sudo killall -9 -u $username 2>/dev/null
        sudo userdel -r $username
        echo "✓ Deleted: $username"
    else
        echo "✗ User '$username' does not exist, skipping..."
    fi
done < "$filename"

echo "Batch deletion complete."
