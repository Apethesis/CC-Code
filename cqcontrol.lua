local ver = 1.2
if not fs.exists("./peclib.lua") then
    local htg = http.get("https://raw.githubusercontent.com/Apethesis/CC-Code/main/peclib.lua")
    local htf = fs.open("./peclib.lua","w")
    htf.write(htg.readAll())
    htf.close()
    htg.close()
end
local peclib = require "peclib"
if peclib.update("https://raw.githubusercontent.com/Apethesis/CC-Code/main/pecchat.lua",ver) then
	error("PecChat updated.",0)
end
local modem = peripheral.find("modem") or error("No modem attached","0")
local keytable = {
    [keys.w] = "w",
    [keys.q] = "q",
    [keys.e] = "e",
    [keys.r] = "r",
    [keys.s] = "s",
    [keys.z] = "z",
    [keys.x] = "x",
    [keys.c] = "c",
    [keys.leftControl] = "ctrl",
    [keys.leftShift] = "shift"
}
if modem.isOpen(4221) == false then
    modem.open(4221)
end
print("Controls:")
print("W = Forward")
print("Q = Turn Left")
print("E = Turn Right")
print("R = Refuel")
print("S = Backwards")
print("Z = Dig")
print("X = Dig Up")
print("C = Dig Down")
print("Left Shift = Up")
print("Left Control = Down")
while true do
    local event, key, is_held = os.pullEvent("key")
    modem.transmit(4221,4221,keytable[key])
    sleep()
end
