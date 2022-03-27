local ver = 1.6
local request = http.get("https://raw.githubusercontent.com/Apethesis/CC-Code/main/comchat.lua")
local version = request.readLine()
request.close()
local verNum = tonumber(version:match("= (.+)"))
if not (ver == verNum) then
    fs.delete("./comchat.lua")
    fs.delete("./comlib.lua")
    local request = http.get("https://raw.githubusercontent.com/Apethesis/CC-Code/main/comchat.lua")
    local newver = fs.open("./comchat.lua","w")
    newver.write(request.readAll())
    request.close()
    newver.close()
    error("ComChat updated.",0)
end
local modem = peripheral.find("modem") or error("No modem attached","0")
if fs.exists("./comlib.lua") == false then
    local htg = http.get("https://raw.githubusercontent.com/Apethesis/CC-Code/main/comlib.lua")
    local htf = fs.open("./comlib.lua","w")
    htf.write(htg.readAll())
    htf.close()
    htg.close()
end
local comlib = require("comlib")
if modem.isOpen(4557) == false then
    modem.open(4557)
    modem.transmit(4557,4557,"Channel open.")
end
local ttable = {}
local rtable = {}
local cooldown = false
if fs.exists("/.exodus/lesserchat/settings") == false then
    local sfile = fs.open("/.exodus/lesserchat/settings","w")
    ttable["name"] = nil
    ttable["message"] = nil
    print("Enter a username:")
    local nm = read()
    ttable["name"] = nm
    sfile.write(textutils.serialize(ttable))
    sfile.close()
else
    local sfile = fs.open("/.exodus/lesserchat/settings","r")
    ttable = textutils.unserialize(sfile.readAll())
end
function send()
    while true do
        local msg = read()
		if string.len(msg) > 100 then
            print("System > Cannot send a message longer than 100 characters.")
        elseif string.len(msg) > 0 and string.len(msg) < 100 then
            ttable["message"] = msg
            modem.transmit(4557,4557,ttable)
            print(ttable["name"].." > "..msg)
            cooldown = true
        elseif cooldown == true then
            print("Cooldown active.")
        end
        sleep()
    end
end
function recieve()
    while true do
        local _,_,_,_,rmsg,_ = os.pullEvent("modem_message")
        rtable = rmsg
        if rtable["name"] ~= ttable["name"] and rtable["message"] ~= msg then
            print(rtable["name"].." > "..rtable["message"])
        end
        sleep()
    end
end
function cooler()
    while true do
        if cooldown == true then
            sleep(1)
            cooldown = false
        end
        sleep()
    end
end
while true do
    parallel.waitForAny(recieve,send,cooler)
    sleep()
end
