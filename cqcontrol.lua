local ver = 1.0
-- 1.0 because peclib-less

require("updater")("https://raw.githubusercontent.com/TotallyNotVirtIO/Peclib-less-Compec-Code/main/cqcontrol.lua", ver)

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
