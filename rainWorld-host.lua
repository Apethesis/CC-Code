rednet.open("top")
local exshelt = 1
while os.time("ingame") < 19 do
    sleep(5)
end
commands.exec('tellraw @a ["The rain is starting..."]')
sleep(0.1)
commands.exec('tellraw @a ["Find shelter."]')
commands.exec('weather rain')
sleep(60)
commands.exec('weather thunder')
sleep(30)
rednet.broadcast("rainstartsense")
local safetbl = {}
for i=1,exshelt do
    local _, th = rednet.receive()
    local goodol = textutils.unserialize(th)
    for k,v in pairs(goodol) do
        safetbl[k] = true
    end
end
local _, plist = commands.exec("list")
local pstr = ""
for k,v in ipairs(plist) do
    pstr = pstr..v
end
plist = string.gmatch(pstr,"%S+")
for i=1,10 do
    table.remove(plist,1)
end
for k,v in ipairs(plist) do
    plist[k] = string.gsub(v,"%,","")
end
for k,v in ipairs(plist) do
    if not safetbl[v] then
        commands.exec("clear "..v)
        commands.exec("kill "..v)
        commands.exec("scoreboard players remove karma 1") 
    else
        commands.exec("scoreboard players add karma 1")
    end
end
commands.exec("time add 7000")
commands.exec("weather clear")
os.reboot()