#!/bin/bash

echo "Enter Bot Token:"
read TOKEN

echo "Enter Admin ID:"
read ADMIN

cat <<EOF > config.py
TOKEN="$TOKEN"
ADMIN="$ADMIN"
EOF

python sobot.py
