import asyncio
from aiogram import Bot, Dispatcher, types
from aiogram.types import ReplyKeyboardMarkup, KeyboardButton, ChatJoinRequest
from aiogram.filters import Command

BOT_TOKEN = "8476925304:AAEcZrPHGzY3PMOWwEbDsetJPvAJF5wdo38"
CHANNEL_URL = "https://t.me/ccc1iii"

bot = Bot(token=BOT_TOKEN)
dp = Dispatcher()

# تخزين طلبات الانضمام مؤقتًا
pending_requests = {}

# زر لمشاركة جهة الاتصال
contact_kb = ReplyKeyboardMarkup(
    keyboard=[
        [KeyboardButton(text=" مشاركة جهة اتصالي", request_contact=True)]
    ],
    resize_keyboard=True,
    one_time_keyboard=True
)

# قائمة الدول العربية المسموح بها مع رمز الدولة
arabic_countries = {
    "المملكة العربية السعودية": "+966",
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

@dp.message(Command("start"))
async def start(message: types.Message):
    # الزر مع style كما طلبت
    keyboard_dict = {
        "inline_keyboard": [
            [
                {
                    "text": " قناة السوبر",
                    "url": CHANNEL_URL,
                    "style": "danger"  # إذا النسخة تدعمه، يظهر أحمر
                }
            ]
        ]
    }

    kb = types.InlineKeyboardMarkup(**keyboard_dict)

    await bot.send_message(
        chat_id=message.chat.id,
        text="مرحبًا بك عزيزي في بوت قبول الأعضاء الحقيقيين.\n"
             "اطلب الانضمام إلى المجموعة التي تريدها.",
        reply_markup=kb
    )

# 🔹 عند استقبال طلب انضمام
@dp.chat_join_request()
async def join_request_handler(req: ChatJoinRequest):
    user_id = req.from_user.id
    pending_requests[user_id] = req

    try:
        await bot.send_message(
            user_id,
            "اهلا بك عزيزي .\n"
            "قم بمشاركة جهة الاتصال الخاصة بك للتحقق من انك ليس روبوت للأنضمام الى المجموعة :𝑺𝒖𝒑𝒆𝒓 𝑻𝒂𝒐\n\n"
            "اضغط على الزر بالأسفل لمشاركة جهة اتصالك مع البوت",
            reply_markup=contact_kb
        )
    except:
        pass

# استقبال جهة الاتصال والتحقق من رمز الدولة
@dp.message()
async def contact_handler(message: types.Message):
    if not hasattr(message, "contact") or not message.contact:
        return  # إذا ما فيها جهة اتصال، نتجاهل الرسالة

    user_id = message.from_user.id
    phone = message.contact.phone_number.strip().replace(" ", "").replace("-", "")

    if not phone.startswith("+"):
        phone = "+" + phone

    allowed = any(phone.startswith(code) for code in arabic_countries.values())

    if allowed:
        if user_id in pending_requests:
            req = pending_requests.pop(user_id)
            await req.approve()
        await message.answer("تم الموافقة على طلب انضمام بنجاح .")
    else:
        countries_list = "\n".join([f"{name} ({code})" for name, code in arabic_countries.items()])
        await message.answer(
            "رقمك محظور من البوت. الدول المسموح بها:\n" + countries_list
        )
        pending_requests.pop(user_id, None)

async def main():
    await dp.start_polling(bot)
if __name__ == "__main__":
    asyncio.run(main())
