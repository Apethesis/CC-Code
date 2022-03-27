local ver = 1.1
local request = http.get("https://raw.githubusercontent.com/Apethesis/CC-Code/main/comquarry.lua")
local version = request.readLine()
request.close()
local verNum = tonumber(version:match("= (.+)"))
if not (ver == verNum) then
    fs.delete("./startup.lua")
    local request = http.get("https://raw.githubusercontent.com/Apethesis/CC-Code/main/comquarry.lua")
    local newver = fs.open("./startup.lua","w")
    newver.write(request.readAll())
    request.close()
    newver.close()
    print("Updated")
    os.reboot()
end
local modem = peripheral.find("modem") or error("No modem attached","0")
local keytable = {
    ["w"] = turtle.forward(),
    ["q"] = turtle.turnLeft(),
    ["e"] = turtle.turnRight(),
    ["r"] = turtle.refuel(),
    ["s"] = turtle.back(),
    ["z"] = turtle.dig("left"),
    ["x"] = turtle.digUp("left"),
    ["c"] = turtle.digDown("left")
}
if modem.isOpen(4221) == false then
    modem.open(4221)
end
while true do
    local _,_,_,_,rmsg,_ = os.pullEvent("modem_message")
    keytable[rmsg]()
    sleep()
end
