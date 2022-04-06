local ver = 1.2
local request = http.get("https://raw.githubusercontent.com/Apethesis/CC-Code/main/pecquarry.lua")
if not fs.exists("./peclib.lua") then
    local htg = http.get("https://raw.githubusercontent.com/Apethesis/CC-Code/main/peclib.lua")
    local htf = fs.open("./peclib.lua","w")
    htf.write(htg.readAll())
    htf.close()
    htg.close()
end
local peclib = require "peclib"
if peclib.update("https://raw.githubusercontent.com/Apethesis/CC-Code/main/pecchat.lua",ver) then
	error("PecQuarry updated.",0)
end
local modem = peripheral.find("modem") or error("No modem attached","0")
local keytable = {
    ["w"] = turtle.forward,
    ["q"] = turtle.turnLeft,
    ["e"] = turtle.turnRight,
    ["r"] = turtle.refuel,
    ["s"] = turtle.back,
    ["z"] = turtle.dig,
    ["x"] = turtle.digUp,
    ["c"] = turtle.digDown,
    ["ctrl"] = turtle.down,
    ["shift"] = turtle.up
}
if modem.isOpen(4221) == false then
    modem.open(4221)
end
while true do
    local _,_,_,_,rmsg,_ = os.pullEvent("modem_message")
    keytable[rmsg]()
    sleep()
end
