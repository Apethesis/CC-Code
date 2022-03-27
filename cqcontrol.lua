local ver = 1.1
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
    print("Updated")
    os.reboot()
end
local modem = peripheral.find("modem") or error("No modem attached","0")
local modtable = {
    [turtle.forward] = "w",
    [turtle.turnLeft] = "q",
    [turtle.turnRight] = "e",
    [turtle.refuel] = "r",
    [turtle.back] = "s",
    [turtle.dig] = "z",
    [turtle.digUp] = "x",
    [turtle.digDown] = "c"
}
local keytable = {
    [keys.w] = turtle.forward,
    [keys.q] = turtle.turnLeft,
    [keys.e] = turtle.turnRight,
    [keys.r] = turtle.refuel,
    [keys.s] = turtle.back,
    [keys.z] = turtle.dig,
    [keys.x] = turtle.digUp,
    [keys.c] = turtle.digDown
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
while true do
    local event, key, is_held = os.pullEvent("key")
    modem.transmit(4221,4221,modtable[keytable[key]])
    sleep()
end
