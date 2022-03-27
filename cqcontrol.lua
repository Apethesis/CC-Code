local ver = 1.2
local request = http.get("https://raw.githubusercontent.com/Apethesis/CC-Code/main/cqcontrol.lua")
local version = request.readLine()
request.close()
local verNum = tonumber(version:match("= (.+)"))
if not (ver == verNum) then
    fs.delete(shell.getRunningProgram())
    local request = http.get("https://raw.githubusercontent.com/Apethesis/CC-Code/main/cqcontrol.lua")
    local newver = fs.open(shell.getRunningProgram(),"w")
    newver.write(request.readAll())
    request.close()
    newver.close()
    error("Updated",0)
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
