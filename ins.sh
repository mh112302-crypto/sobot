#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "=== Bot Installer ==="
read -p "Enter Bot Token: " TOKEN
read -p "Enter Admin ID: " ADMIN

# تحقق بسيط
case "$TOKEN" in
  *:*) ;;
  *) echo "Token format wrong (must contain ':')."; exit 1;;
esac

# اكتب القيم داخل config.py
cat > config.py <<EOF
TOKEN = "$TOKEN"
ADMIN = "$ADMIN"
EOF

# ثبت المكتبة المطلوبة
python -m pip install --upgrade pip >/dev/null 2>&1 || true
python -m pip install pyTelegramBotAPI

echo "Starting yxpyx
bot..."
python sobot.py
