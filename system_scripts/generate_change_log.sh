#!/bin/bash

DIR="/srv/shared_files/sys_logs"
DATE=$(date +%F)
FILE="$DIR/changelog_$DATE"

mkdir -p "$DIR"
touch "$FILE"

echo "Created: $FILE"
