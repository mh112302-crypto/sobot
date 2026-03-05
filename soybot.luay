-- ملف: soybot.lua
local https = require("ssl.https")
local json = require("dkjson")
local socket = require("socket")  -- ضروري للانتظار

local token = "8558893967:AAFBFjRGE10nyaYeQ9cE4uOmy3uwYukEqlg"

function sendMessage(chat_id, text)
    local url = "https://api.telegram.org/bot"..token.."/sendMessage?chat_id="..chat_id.."&text="..text
    https.request(url)
end

function getUpdates(offset)
    local url = "https://api.telegram.org/bot"..token.."/getUpdates?timeout=60"
    if offset then url = url .. "&offset="..offset end
    local body, code = https.request(url)
    if body then
        local data = json.decode(body)
        return data
    end
    return nil
end

print("بوت شغّال! 🚀")
local last_update_id = 0

while true do
    local updates = getUpdates(last_update_id + 1)
    if updates and updates.result then
        for _, update in ipairs(updates.result) do
            last_update_id = update.update_id
            if update.message then
                local msg = update.message.text or ""
                local chat = update.message.chat.id
                print("استلمت رسالة: "..msg)
                if msg == "/start" then
                    sendMessage(chat, "أهلاً! هذا بوت تجربة على Lua 🤖")
                else
                    sendMessage(chat, "كتبت: "..msg)
                end
            end
        end
    end
    socket.sleep(1)  -- لتقليل استهلاك المعالج
end
