local sensor = peripheral.wrap("back")
rednet.open("left")
local _, startsense = rednet.receive()
local safetbl = {}
local sheltersize = {6,3,6}
if not (startsense == "rainstartsense") then
    _, startsense = rednet.receive()
else
    local ptbl = sensor.sense()
    for k,v in pairs(ptbl) do
        if v.key == "minecraft:player" then
            ptbl[k].y = ptbl[k].y + 2
            if math.floor(v.x) < sheltersize[1] and math.floor(v.x) >= 0 and math.floor(v.y) < sheltersize[2] and math.floor(v.y) >= 0 and math.floor(v.z) < sheltersize[3] and math.floor(v.z) >= 0 then
                safetbl[v.name] = true
            end
        end
    end
    rednet.broadcast(textutils.serialize(safetbl))
end