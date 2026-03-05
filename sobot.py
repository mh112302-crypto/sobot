import telebot
from config import TOKEN, ADMIN

bot = telebot.TeleBot(TOKEN)

@bot.message_handler(commands=['start'])
def start(message):
    if str(message.from_user.id) == ADMIN:
        bot.reply_to(message, "هلا مطور البوت 👑")
    else:
        bot.reply_to(message, "اهلا بك في البوت")

print("Bot is running...")
bot.infinity_polling()
