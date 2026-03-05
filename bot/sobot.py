import telebot
from telebot.types import ReplyKeyboardMarkup, KeyboardButton, InlineKeyboardMarkup, InlineKeyboardButton
from config import TOKEN, ADMIN

bot = telebot.TeleBot(TOKEN)

pending_requests = {}

CHANNEL_URL = "https://t.me/ccc1iii"

contact_kb = ReplyKeyboardMarkup(resize_keyboard=True, one_time_keyboard=True)
contact_kb.add(KeyboardButton("مشاركة جهة اتصالي", request_contact=True))

arabic_countries = {
    "السعودية": "+966",
    "الإمارات": "+971",
    "قطر": "+974",
    "الكويت": "+965",
    "البحرين": "+973",
    "عمان": "+968",
    "العراق": "+964",
    "مصر": "+20",
    "الأردن": "+962",
    "سوريا": "+963",
    "لبنان": "+961",
    "فلسطين": "+970",
    "المغرب": "+212",
    "الجزائر": "+213",
    "تونس": "+216",
    "ليبيا": "+218",
    "السودان": "+249",
    "اليمن": "+967"
}

@bot.message_handler(commands=['start'])
def start(message):

    markup = InlineKeyboardMarkup()
    markup.add(
        InlineKeyboardButton(
            "قناة السوبر",
            url=CHANNEL_URL
        )
    )

    bot.send_message(
        message.chat.id,
        "مرحبًا بك عزيزي في بوت قبول الأعضاء الحقيقيين.\nاطلب الانضمام إلى المجموعة.",
        reply_markup=markup
    )


@bot.chat_join_request_handler()
def join_request(req):

    user_id = req.from_user.id
    pending_requests[user_id] = req

    try:
        bot.send_message(
            user_id,
            "اهلا بك عزيزي.\nقم بمشاركة جهة الاتصال الخاصة بك للتحقق.",
            reply_markup=contact_kb
        )
    except:
        pass


@bot.message_handler(content_types=['contact'])
def contact_handler(message):

    user_id = message.from_user.id
    phone = message.contact.phone_number.strip().replace(" ", "").replace("-", "")

    if not phone.startswith("+"):
        phone = "+" + phone

    allowed = any(phone.startswith(code) for code in arabic_countries.values())

    if allowed:

        if user_id in pending_requests:
            req = pending_requests.pop(user_id)
            bot.approve_chat_join_request(req.chat.id, user_id)

        bot.send_message(user_id, "تم قبولك في المجموعة بنجاح.")

    else:

        countries_list = "\n".join(
            [f"{name} ({code})" for name, code in arabic_countries.items()]
        )

        bot.send_message(
            user_id,
            "رقمك غير مسموح.\nالدول المسموح بها:\n" + countries_list
        )

        pending_requests.pop(user_id, None)


print("Bot is running...")

bot.infinity_polling()
